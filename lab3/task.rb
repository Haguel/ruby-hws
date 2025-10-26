require 'find'
require 'digest/sha2'
require 'json'
require 'logger' # Використовуємо стандартний логер Ruby

class DuplicateScanner

  # Відкриваємо доступ до фінального звіту
  attr_reader :report

  #
  # Ініціалізатор класу (конструктор)
  #
  def initialize(root_path, ignore_paths = [])
    @root_path = root_path
    # Перетворюємо ігноровані шляхи на повні (абсолютні)
    @ignore_paths = ignore_paths.map { |p| File.expand_path(p, @root_path) }

    @report = {} # Тут зберігатиметься результат

    # Налаштовуємо логер для виведення в консоль
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "#{msg}\n"
    end
  end

  #
  # Головний публічний метод для запуску сканування
  #
  def scan
    @logger.info "--- Початок сканування у '#{@root_path}' ---"

    # Рекурсивно збираємо всі файли
    all_files = collect_files
    @logger.info "Знайдено #{all_files.size} файлів для аналізу."

    # Групуємо файли за розміром
    # (Пропускаємо групи, де лише 1 файл, бо в нього не може бути дублікатів)
    files_by_size = group_by_size(all_files)
    @logger.info "Знайдено #{files_by_size.size} груп файлів з однаковим розміром."

    # Крок 3: Знаходимо справжні дублікати, порівнюючи хеші
    duplicate_groups = find_duplicates(files_by_size)
    @logger.info "Знайдено #{duplicate_groups.size} груп дублікатів."

    # Крок 4: Формуємо та записуємо звіт
    build_and_write_report(all_files.size, duplicate_groups)

    @logger.info "--- Сканування завершено ---"
  end

  # ---
  # Приватні методи (внутрішня логіка класу)
  # ---
  private

  #
  # Збір усіх файлів
  #
  def collect_files
    files = []
    Find.find(@root_path) do |path|
      # Пропускаємо директорії
      next if File.directory?(path)

      # Пропускаємо шляхи, які користувач вказав у 'ignore'
      full_path = File.expand_path(path)
      next if @ignore_paths.any? { |ig| full_path.start_with?(ig) }

      begin
        stat = File.stat(path)
        # Пропускаємо порожні файли (0 байт)
        next if stat.size == 0

        # Збираємо дані: шлях, розмір, та *id пристрою + inode*
        # 'dev' (пристрій) та 'inode' потрібні для оптимізації на Кроці 3
        files << {
          path: path,
          size: stat.size,
          dev: stat.dev,
          inode: stat.ino
        }
      rescue Errno::ENOENT, Errno::EACCES => e
        # Пропускаємо файли, які не можемо прочитати
        @logger.warn "(!) Пропуск (немає доступу): #{path} (#{e.message})"
      end
    end
    files
  end

  #
  # Групування за розміром
  #
  def group_by_size(files)
    @logger.info "Групуємо файли за розміром..."
    # Використовуємо 'group_by' - це дуже "рубі-вей" (ідіоматично)
    # і одразу відбираємо (.select) лише ті групи, де > 1 файлу
    files.group_by { |f| f[:size] }
         .select { |size, group| group.size > 1 }
  end

  #
  # Пошук дублікатів за хешем (найскладніша частина)
  #
  def find_duplicates(size_groups)
    @logger.info "Обчислюємо хеші для груп..."
    all_duplicate_groups = []

    # 'each.with_index' для красивого логування прогресу
    size_groups.each.with_index do |(size, files_in_group), i|
      @logger.info "  [#{i+1}/#{size_groups.size}] Обробка групи розміром #{size} байт..."

      # ---
      # ОПТИМІЗАЦІЯ
      # Групуємо файли за 'inode' та 'dev'.
      # Файли з однаковим [dev, inode] - це ОДИН І ТОЙ ЖЕ файл на диску, але з різними іменами.
      # Нам потрібно порахувати хеш для нього лише ОДИН РАЗ.
      # ---
      inode_groups = files_in_group.group_by { |f| [f[:dev], f[:inode]] }

      # Тепер хешуємо
      hash_to_files = Hash.new { |h, k| h[k] = [] }

      inode_groups.each do |(dev, inode), files_with_same_inode|
        # Беремо ПЕРШИЙ файл з групи хардлінків як "представника"
        representative_file = files_with_same_inode.first

        begin
          hash = Digest::SHA256.file(representative_file[:path]).hexdigest

          # До цього хешу додаємо ВСІ ШЛЯХИ хардлінків
          all_paths = files_with_same_inode.map { |f| f[:path] }
          hash_to_files[hash] += all_paths

        rescue Errno::ENOENT, Errno::EACCES => e
          @logger.warn "(!) Пропуск (помилка хешування): #{representative_file[:path]} (#{e.message})"
        end
      end

      # Тепер у 'hash_to_files' в нас лише групи зі справжніми дублікатами
      hash_to_files.select { |hash, paths| paths.size > 1 }.each do |hash, paths|
        saved = size * (paths.size - 1)
        all_duplicate_groups << {
          size_bytes: size,
          saved_if_dedup_bytes: saved,
          hash: hash, # Додамо хеш у звіт для наочності
          files: paths.sort
        }
      end
    end

    all_duplicate_groups
  end

  # Створення та запис звіту
  def build_and_write_report(scanned_count, duplicate_groups)
    # Сортуємо групи від найбільших до найменших
    sorted_groups = duplicate_groups.sort_by { |g| -g[:size_bytes] }

    total_dupes = sorted_groups.sum { |g| g[:files].size - 1 }
    total_saved = sorted_groups.sum { |g| g[:saved_if_dedup_bytes] }

    @report = {
      scanned_files: scanned_count,
      total_duplicates: total_dupes,
      total_saved_if_dedup_bytes: total_saved,
      total_saved_mb: (total_saved / (1024.0 * 1024.0)).round(2),
      groups: sorted_groups
    }

    report_path = 'duplicates.json'
    begin
      File.write(report_path, JSON.pretty_generate(@report))
      @logger.info "Звіт збережено у #{report_path}"

      @logger.info "--- Підсумки ---"
      @logger.info "Проскановано файлів: #{scanned_count}"
      @logger.info "Знайдено дублікатів: #{total_dupes} у #{sorted_groups.size} групах."
      @logger.info "Потенційна економія: #{@report[:total_saved_mb]} MB"

    rescue => e
      @logger.error "(!) НЕ ВДАЛОСЯ ЗАПИСАТИ ЗВІТ: #{e.message}"
    end
  end

end


# Точка входу в скрипт
if __FILE__ == $0
  root = ARGV[0] || Dir.pwd
  ignore = ARGV[1..] || []

  # Створюємо екземпляр нашого класу та запускаємо сканування
  scanner = DuplicateScanner.new(root, ignore)
  scanner.scan
end


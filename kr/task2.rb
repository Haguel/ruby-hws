# frozen_string_literal: true

class Notifier
  def initialize(*adapters)
    @adapters = adapters
  end

  def send_notification(message)
    puts "Починаю розсилку: '#{message}'..."

    @adapters.each do |adapter|
      adapter.deliver(message)
    end

    puts "Розсилку завершено."
  end
end


class EmailAdapter
  def initialize(email)
    @email = email
    puts "(Налаштовано EmailAdapter для #{@email})"
  end

  def deliver(message)
    puts "  [EMAIL] 📧 Відправлено '#{message}' на пошту #{@email}"
  end
end

class SlackAdapter
  def initialize(channel)
    @channel = channel
    puts "(Налаштовано SlackAdapter для каналу ##{@channel})"
  end

  def deliver(message)
    puts "  [SLACK] 💬 Постинг '#{message}' у канал ##{@channel}"
  end
end

email_sender = EmailAdapter.new("admin@example.com")
slack_sender = SlackAdapter.new("general")

puts "\n--- Сценарій 1: Відправка тільки на Email ---"
email_notifier = Notifier.new(email_sender)
email_notifier.send_notification("Планове обслуговування сервера.")

puts "\n--- Сценарій 2: Відправка на Email та Slack ---"
main_notifier = Notifier.new(email_sender, slack_sender)
main_notifier.send_notification("Критична помилка!")
# frozen_string_literal: true

class FileBatchEnumerator
  include Enumerable

  def initialize(file_path, batch_size)
    raise ArgumentError, "batch_size має бути > 0" if batch_size <= 0
    @file_path = file_path
    @batch_size = batch_size
    @file = File.open(@file_path, 'r')
  end

  def next
    batch = []
    @batch_size.times do
      line = @file.gets
      break if line.nil?
      batch << line.chomp
    end

    if batch.empty?
      close
      raise StopIteration
    end

    batch
  end

  def has_next?
    !@file.eof?
  end

  def close
    @file.close if @file && !@file.closed?
  end

  def rewind
    close
    @file = File.open(@file_path, 'r')
  end

  def each
    return enum_for(:each) unless block_given?

    rewind unless @file.pos == 0
    loop { yield self.next }
  rescue StopIteration
  ensure
    close
  end
end

file_name = 'my_large_file.txt'
File.open(file_name, 'w') do |f|
  (1..15).each { |i| f.puts("Рядок #{i}") }
end

puts "--- Приклад 1: Зовнішній ітератор (батч = 4) ---"
iterator = nil
begin
  iterator = FileBatchEnumerator.new(file_name, 4)
  loop do
    batch = iterator.next
    puts "  Отримано батч: #{batch.inspect}"
  end
rescue StopIteration
  puts "Кінець файлу."
ensure
  iterator&.close
end

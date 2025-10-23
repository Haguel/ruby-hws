class WordCounter
  def stats(text)
    return '0 слів, найдовше: , унікальних: 0' if text.to_s.strip.empty?

    words = text.split

    "#{words.count} слів, найдовше: #{words.max_by(&:length)}, унікальних: #{words.map(&:downcase).uniq.count}"
  end
end


counter = WordCounter.new

text = 'Ruby is fun and ruby is powerful'
puts "Вхідний текст: \"#{text}\""
puts "Результат: #{counter.stats(text)}"

puts

text2 = 'Hello World! Hello Again and again'
puts "Вхідний текст: \"#{text2}\""
puts "Результат: #{counter.stats(text2)}"
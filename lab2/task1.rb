class CakeSlicer
  def initialize
    @memo = {}
  end

  def slice(cake_str)
    cake_lines = cake_str.strip.split("\n")
    solutions = find_solutions(cake_lines)

    return [] if solutions.empty?

    solutions.max_by { |solution| solution.first.split("\n").first.length }
  end

  private

  def find_solutions(cake_lines)
    cake_key = cake_lines.join("\n")
    return @memo[cake_key] if @memo.key?(cake_key)

    total_raisins = cake_key.count('o')
    return [[cake_key]] if total_raisins == 1

    height = cake_lines.length
    width = cake_lines.first.length
    solutions = []

    # Horizontal cuts
    (0...height - 1).each do |r|
      top_part = cake_lines[0..r]
      bottom_part = cake_lines[(r + 1)..-1]

      top_raisins = top_part.join.count('o')
      next if top_raisins.zero? || top_raisins == total_raisins

      if top_part.length * (total_raisins - top_raisins) == bottom_part.length * top_raisins
        find_combinations(solutions, find_solutions(top_part), find_solutions(bottom_part))
      end
    end

    # Vertical cuts
    (0...width - 1).each do |c|
      left_part = cake_lines.map { |row| row[0..c] }
      right_part = cake_lines.map { |row| row[(c + 1)..-1] }

      left_raisins = left_part.join.count('o')
      next if left_raisins.zero? || left_raisins == total_raisins

      if left_part.first.length * (total_raisins - left_raisins) == right_part.first.length * left_raisins
        find_combinations(solutions, find_solutions(left_part), find_solutions(right_part))
      end
    end

    @memo[cake_key] = solutions
  end

  def find_combinations(solutions, set1, set2)
    set1.each do |s1|
      set2.each do |s2|
        solutions << s1 + s2
      end
    end
  end
end

def print_solution(pieces)
  puts "["
  pieces.each_with_index do |piece, i|
    puts "  \""
    piece.split("\n").each { |line| puts "    #{line}" }
    puts "  \"" + (i < pieces.length - 1 ? "," : "")
  end
  puts "]"
end


# --- Приклади ---
slicer = CakeSlicer.new

puts "--- Перший приклад ---"
cake1 = <<~CAKE
........
..o.....
...o....
........
CAKE
solution1 = slicer.slice(cake1)
print_solution(solution1)


puts "\n--- Другий приклад ---"
cake2 = <<~CAKE
.o......
......o.
....o...
..o.....
CAKE
solution2 = CakeSlicer.new.slice(cake2)
print_solution(solution2)


puts "\n--- Третій приклад ---"
cake3 = <<~CAKE
.o.o....
........
....o...
........
.....o..
........
CAKE
solution3 = CakeSlicer.new.slice(cake3)
print_solution(solution3)

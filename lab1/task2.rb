class GuessingGame
  def play_game
    secret_number = rand(1..100)
    attempts = 0

    puts "Я загадав число від 1 до 100. Спробуйте його вгадати."

    loop do
      attempts += 1
      print "Ваша спроба №#{attempts}: "
      guess = gets.to_i

      if guess < secret_number
        puts "Ні, моє число більше."
      elsif guess > secret_number
        puts "Ні, моє число менше."
      else
        puts "Вітаю! Ви вгадали число #{secret_number} за #{attempts} спроб."
        break
      end
    end
  end
end

GuessingGame.new.play_game
# frozen_string_literal: true

module Planner
  def self.plan(recipes, pantry, ingredients_db, price_list)
    # 1. Агрегуємо потреби зі ВСІХ рецептів
    total_needs = {}
    recipes.each do |recipe|
      recipe.need.each do |name, quantity|
        total_needs[name] = (total_needs[name] || 0) + quantity
      end
    end

    total_calories = 0.0
    total_cost = 0.0

    puts '--- План приготування ---'
    puts '---------------------------'

    all_ingredient_names = total_needs.keys

    all_ingredient_names.each do |name|
      ingredient = ingredients_db[name]
      price = price_list[name]

      unless ingredient && price
        puts "!!! Увага: Немає даних (калорії/ціна) для '#{name}'."
        next
      end

      # 3. Рахуємо потребу, наявність, дефіцит
      needed_qty = total_needs[name]
      available_qty = pantry.available_for(name)
      deficit = [0, needed_qty - available_qty].max

      # 4. Рахуємо калорії та вартість
      total_calories += needed_qty * ingredient.calories_per_unit
      total_cost += needed_qty * price

      # 5. Виводимо звіт по інгредієнту
      base_unit = ingredient.base_unit
      puts "#{name.to_s.capitalize}:"
      puts "  Потрібно: #{needed_qty.round(2)} #{base_unit}"
      puts "  В коморі:  #{available_qty.round(2)} #{base_unit}"
      puts "  Дефіцит:  #{deficit.round(2)} #{base_unit}"
    end

    puts '---------------------------'
    puts "Загальна калорійність: #{total_calories.round(2)} ккал"
    puts "Загальна вартість: #{total_cost.round(2)} (грошових одиниць)"
    puts '---------------------------'
  end
end
# frozen_string_literal: true

require_relative './unit_converter'

# --- Клас 4: Рецепт ---
class Recipe
  attr_reader :name

  # items - це масив хешів
  def initialize(name, steps, items)
    @name = name
    @steps = steps
    @items = items
  end

  # Рахує загальну потребу інгредієнтів в *базових* одиницях
  def need
    total_needs = {}

    @items.each do |item|
      ingredient = item[:ingredient]
      quantity = item[:quantity]
      unit = item[:unit]

      # Використовуємо підключений модуль
      unless UnitConverter.are_compatible?(ingredient.base_unit, unit)
        raise "Рецепт '#{@name}': Невідповідність одиниць для #{ingredient.name}"
      end

      # Використовуємо підключений модуль
      base_quantity = UnitConverter.to_base_quantity(quantity, unit)
      name_sym = ingredient.name

      total_needs[name_sym] = (total_needs[name_sym] || 0) + base_quantity
    end

    total_needs
  end
end
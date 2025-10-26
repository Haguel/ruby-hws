# frozen_string_literal: true

require_relative './unit_converter'

class Pantry
  def initialize
    # @storage - це Хеш { :flour => 1000, :eggs => 6 }
    @storage = {}
  end

  # Додає інгредієнт до комори
  def add(ingredient_name, quantity, unit)
    # Використовуємо підключений модуль
    base_quantity = UnitConverter.to_base_quantity(quantity, unit)
    name_sym = ingredient_name.to_sym
    @storage[name_sym] = (@storage[name_sym] || 0) + base_quantity
  end

  # Повертає наявну кількість інгредієнта (в базових одиницях)
  def available_for(ingredient_name)
    @storage[ingredient_name.to_sym] || 0
  end
end
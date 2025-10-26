# frozen_string_literal: true

class Ingredient
  attr_reader :name, :base_unit, :calories_per_unit

  def initialize(name, base_unit, calories_per_unit)
    @name = name
    @base_unit = base_unit
    @calories_per_unit = calories_per_unit
  end
end
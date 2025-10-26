# frozen_string_literal: true

module UnitConverter
  # Конвертує кількість до базової одиниці (г, мл, шт)
  def self.to_base_quantity(quantity, unit)
    case unit
    when :kg
      quantity * 1000 # в :g
    when :l
      quantity * 1000 # в :ml
    when :g, :ml, :pcs
      quantity # Вже в базовій
    else
      raise "Непідтримувана одиниця: #{unit}"
    end
  end

  # Перевіряє, чи сумісні одиниці (наприклад, :kg та :g)
  def self.are_compatible?(unit1, unit2)
    mass = [:g, :kg]
    volume = [:ml, :l]
    count = [:pcs]

    (mass.include?(unit1) && mass.include?(unit2)) ||
      (volume.include?(unit1) && volume.include?(unit2)) ||
      (count.include?(unit1) && count.include?(unit2))
  end
end
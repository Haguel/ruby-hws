# frozen_string_literal: true


require_relative './unit_converter'
require_relative './ingredient'
require_relative './pantry'
require_relative './recipe'
require_relative './planner'

# --- 1. Налаштування бази даних інгредієнтів (Калорійність) ---
INGREDIENTS_DB = {
  :eggs =>    Ingredient.new(:eggs, :pcs, 72.0),
  :milk =>    Ingredient.new(:milk, :ml, 0.06),
  :flour =>   Ingredient.new(:flour, :g, 3.64),
  :pasta =>   Ingredient.new(:pasta, :g, 3.5),
  :sauce =>   Ingredient.new(:sauce, :ml, 0.2),
  :cheese =>  Ingredient.new(:cheese, :g, 4.0)
}.freeze

# --- 2. Налаштування прайс-листа (Ціни за базову одиницю) ---
PRICE_LIST = {
  :flour => 0.02,
  :milk => 0.015,
  :eggs => 6.0,
  :pasta => 0.03,
  :sauce => 0.025,
  :cheese => 0.08
}.freeze

# --- 3. Наповнення комори (Pantry) ---
pantry = Pantry.new
pantry.add(:flour, 1, :kg)
pantry.add(:milk, 0.5, :l)
pantry.add(:eggs, 6, :pcs)
pantry.add(:pasta, 300, :g)
pantry.add(:cheese, 150, :g)

# --- 4. Створення рецептів ---
recipe_omelette = Recipe.new(
  'Омлет',
  ['Змішати', 'Смажити'],
  [
    { ingredient: INGREDIENTS_DB[:eggs], quantity: 3, unit: :pcs },
    { ingredient: INGREDIENTS_DB[:milk], quantity: 100, unit: :ml },
    { ingredient: INGREDIENTS_DB[:flour], quantity: 20, unit: :g }
  ]
)

recipe_pasta = Recipe.new(
  'Паста з сиром',
  ['Зварити', 'Додати соус'],
  [
    { ingredient: INGREDIENTS_DB[:pasta], quantity: 200, unit: :g },
    { ingredient: INGREDIENTS_DB[:sauce], quantity: 150, unit: :ml },
    { ingredient: INGREDIENTS_DB[:cheese], quantity: 50, unit: :g }
  ]
)

# --- 5. Запуск планувальника ---
recipes_to_cook = [recipe_omelette, recipe_pasta]

# Використовуємо модуль Planner з planner.rb
Planner.plan(recipes_to_cook, pantry, INGREDIENTS_DB, PRICE_LIST)
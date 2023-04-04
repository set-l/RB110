def select_fruit(produce)
  fruit = {}

  produce.each do |item, produce_type|
    fruit[item] = produce_type if produce_type == 'Fruit'
  end

  fruit
end

produce = {
  'apple' => 'Fruit',
  'carrot' => 'Vegetable',
  'pear' => 'Fruit',
  'broccoli' => 'Vegetable'
}

# p select_fruit(produce) # => {"apple"=>"Fruit", "pear"=>"Fruit"}


def double_numbers!(numbers)
  i = 0
  loop do
    numbers[i] *= 2
    i += 1
    break if i >= numbers.length
  end

  numbers
end

my_numbers = [1, 4, 3, 7, 2, 6]
# p double_numbers!(my_numbers) # => [2, 8, 6, 14, 4, 12]
# p my_numbers


def double_odd_numbers(numbers)
  doubled = []
  i = 0

  loop do
    break if i >= numbers.length

    transformed = i.odd? ? numbers[i] * 2 : numbers[i]
    doubled << transformed
    i += 1
  end

  doubled
end

# my_numbers = [1, 4, 3, 7, 2, 6]
# p double_odd_numbers(my_numbers)  # => [1, 8, 3, 14, 2, 12]
# # not mutated
# p my_numbers                      # => [1, 4, 3, 7, 2, 6]



def multiply(numbers, by)
  multiplied = []

  numbers.each do |num|
    multiplied << num * by
  end

  multiplied
end

my_numbers = [1, 4, 3, 7, 2, 6]
p multiply(my_numbers, 3) # => [3, 12, 9, 21, 6, 18]

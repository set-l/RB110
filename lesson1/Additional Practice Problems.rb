flintstones = ["Fred", "Barney", "Wilma", "Betty", "Pebbles", "BamBam"]

# p flintstones.map { |name| [name, flintstones.index(name)] }.to_h


ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 5843, "Eddie" => 10, "Marilyn" => 22, "Spot" => 237 }

# p ages.values.sum


ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }

ages.delete_if { |_, age| age >= 100 }
# p ages


ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 5843, "Eddie" => 10, "Marilyn" => 22, "Spot" => 237 }

# p ages.values.min


flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

# p flintstones.index { |name| name.start_with? 'Be' }


flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

# p flintstones.map! { |name| name[0..2] } # name[0, 3]

statement = "The Flintstones Rock"

letters = statement.split.join.chars
# p letters.each_with_object({}) { |char, object| object[char] = object.fetch(char, 0) + 1 }


# numbers = [1, 2, 3, 4]
# numbers.each do |number|
#   p number
#   numbers.shift(1)
# end

# The array is modified each iteration by removing the first element
# each iterates through arrays using an incrementing index value
# modifying the array can change the value of the element at the index

# This outputs: 1, 3
# On the first iteration, the argument is 1 (at index 0), and 2 is removed
# On the second iteration, the argument is 3 (at index 1), and 4 is removed
# The next iteration (at index 2) doesn't exist

# numbers = [1, 2, 3, 4]
# numbers.each do |number|
#   p number
#   numbers.pop(1)
# end

# This outputs: 1, 2
# On the first iteration, the argument is 1 (at index 0), and 4 is removed
# On the second iteration, the argument is 2 (at index 1), and 3 is removed
# The next iteration (at index 2) doesn't exist


words = "the flintstones rock"

def words.titleize()
  self.split.map! { |word| word.capitalize! }.join(' ')
end

# p words.titleize


munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

SENIOR_AGE = 65
ADULT_AGE = 18

munsters.each_value do |info|
  info['age_group'] = if info['age'] >= SENIOR_AGE
                        'senior'
                      elsif info['age'] >= ADULT_AGE 
                        'adult'
                      else
                        'kid'
                      end
end

# munsters.each { |k, v| p "#{k} => #{v}"}

arr = ['10', '11', '9', '7', '8']

i = 0
new_arr = []

while i < arr.length
  num = arr[i].to_i
  insert = 0
  
  while num < new_arr[insert].to_i
    insert += 1
  end

  new_arr.insert(insert, arr[i])
  i += 1
end

# p new_arr

# p arr.sort { |a, b| b.to_i <=> a.to_i }


books = [
  {title: 'One Hundred Years of Solitude', author: 'Gabriel Garcia Marquez', published: '1967'},
  {title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', published: '1925'},
  {title: 'War and Peace', author: 'Leo Tolstoy', published: '1869'},
  {title: 'Ulysses', author: 'James Joyce', published: '1922'}
]

# p books.sort_by { |book| book[:published].to_i }


arr1 = ['a', 'b', ['c', ['d', 'e', 'f', 'g']]]

arr2 = [{first: ['a', 'b', 'c'], second: ['d', 'e', 'f']}, {third: ['g', 'h', 'i']}]

arr3 = [['abc'], ['def'], {third: ['ghi']}]

hsh1 = {'a' => ['d', 'e'], 'b' => ['f', 'g'], 'c' => ['h', 'i']}

hsh2 = {first: {'d' => 3}, second: {'e' => 2, 'f' => 1}, third: {'g' => 0}}

# p arr1[-1][-1][-1] # arr1.last.last.last
# p arr2.last[:third].first
# p arr3.last[:third].first[0]
# p hsh1['b'].last
# p hsh2[:third].keys.first # hsh2[:third].key(0)


arr1 = [1, [2, 3], 4]

arr2 = [{a: 1}, {b: 2, c: [7, 6, 5], d: 4}, 3]

hsh1 = {first: [1, 2, [3]]}

hsh2 = {['a'] => {a: ['1', :two, 3], b: 4}, 'b' => 5}

arr1[1][1] = 4
arr2[2] = 4
hsh1[:first].last[0] = 4
hsh2[['a']][:a][-1] = 4
# p arr1
# p arr2
# p hsh1
# p hsh2


munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

# ages = munsters.values.map do |info|
#   info['gender'] == 'male' ? info['age'] : 0
# end
# p ages.sum

# p(munsters.reduce(0) do |sum, (_, info)|
#   info['gender'] == 'male' ? sum + info['age'] : sum
# end)


munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

# munsters.each do |name, info|
#   p "#{name} is a #{info['age']}-year-old #{info['gender']}"
# end


a = 2
b = [5, 8]
arr = [a, b]

arr[0] += 2
arr[1][0] -= a

# a = 2
# b = [3, 8]


hsh = {first: ['the', 'quick'], second: ['brown', 'fox'], third: ['jumped'], fourth: ['over', 'the', 'lazy', 'dog']}

# hsh.each do |_, strings|
#   strings.each do |string|
#     string.chars.each do |char|
#       puts char if char.downcase.match(/[aeiou]/)
#     end
#   end
# end


arr = [['b', 'c', 'a'], [2, 1, 3], ['blue', 'black', 'green']]

sorted = arr.map do |subarray|
  subarray.sort { |a, b| b <=> a }
end

# p sorted


incremented = [{a: 1}, {b: 2, c: 3}, {d: 4, e: 5, f: 6}].map do |hsh|
  hsh.map { |k, v| [k, v + 1] }.to_h
end

# p incremented


arr = [[2], [3, 5, 7, 12], [9], [11, 13, 15]]

new_arr = arr.map do |subarray|
  subarray.select { |i| (i % 3).zero? }
end

# p new_arr


arr = [[:a, 1], ['b', 'two'], ['sea', {c: 3}], [{a: 1, b: 2, c: 3, d: 4}, 'D']]
# expected return value: {:a=>1, "b"=>"two", "sea"=>{:c=>3}, {:a=>1, :b=>2, :c=>3, :d=>4}=>"D"}

hsh_from_arr = arr.each_with_object({}) do |subarray, hsh|
  hsh[subarray.first] = subarray.last
end

# p hsh_from_arr


arr = [[1, 6, 9], [6, 1, 7], [1, 8, 3], [1, 5, 9]]

sorted = arr.sort_by do |subarray|
  subarray.select { |i| i.odd? }
end

# p sorted


hsh = {
  'grape' => {type: 'fruit', colors: ['red', 'green'], size: 'small'},
  'carrot' => {type: 'vegetable', colors: ['orange'], size: 'medium'},
  'apple' => {type: 'fruit', colors: ['red', 'green'], size: 'medium'},
  'apricot' => {type: 'fruit', colors: ['orange'], size: 'medium'},
  'marrow' => {type: 'vegetable', colors: ['green'], size: 'large'},
}

new_arr = hsh.values.map do |info|
  if info[:type] == 'fruit'
    info[:colors].map { |color| color.capitalize }
  else
    info[:size].upcase
  end
end

# p new_arr


arr = [{a: [1, 2, 3]}, {b: [2, 4, 6], c: [3, 6], d: [4]}, {e: [8], f: [6, 10]}]

even_hashes = arr.select do |hsh|
  hsh.values.all? do |num_arr|
    num_arr.all? do |num|
      num.even?
    end
  end
end

# p even_hashes

HEX = ('a'..'f').to_a + ('0'..'9').to_a
FORMAT = [8, 4, 4, 4, 12]

def uuid
  str = ''

  FORMAT.each do |section|
    section.times do
      str << HEX.sample
    end

    str << '-' unless section == 12
  end

  str
end

# p uuid
# require 'securerandom'
# p SecureRandom.uuid

# [1, 2, 3].select do |num|
#   num > 5
#   'hi'
# end

# This returns an array containing all of the receiver's elements for which the block returned true.
# 'hi' evaluates to true, so a new identical array is returned: [1, 2, 3]


# ['ant', 'bat', 'caterpillar'].count do |str|
#   str.length < 4
# end

# count evaluates the truthiness of the block's return value and increments an integer (+ 1, starting from 0) if it evaluates to true.
# this count will return 2


# [1, 2, 3].reject do |num|
#   puts num
# end

# reject returns a new array consisting of the elements for which the block's return value evaluated to false.
# this reject will return [1, 2, 3], since puts returns nil and evaluates to false.


# ['ant', 'bear', 'cat'].each_with_object({}) do |value, hash|
#   hash[value[0]] = value
# end

# each_with_object takes an object as an argument, and passes it to the block as the second argument, allowing it to be used directly within the block.
# In this block, each element in the receiver called 'value' is being assigned in the 'hash' object as a value with the key being the first index of 'value'
# This each_with_object will return { 'a': 'ant', 'b': 'bear', 'c': 'cat' }


# hash = { a: 'ant', b: 'bear' }
# hash.shift

# shift removes and returns the first pair of the hash
# this can be checked by ensuring 'hash' has been mutated after calling shift: p hash == { b: 'bear' }


# ['ant', 'bear', 'caterpillar'].pop.size

# this destructively removes and returns the last element 'caterpillar', then gets the size/length of the string as an integer.
# this returns 11


# [1, 2, 3].any? do |num|
#   puts num
#   num.odd?
# end

# the block's return value is the return value of the predicate 'odd?' integer method. 'odd?' returns true if the integer is odd, false otherwise.
# this 'any?' will return true and will output 1


# arr = [1, 2, 3, 4, 5]
# arr.take(2)

# take returns a new array containing the first n elements: [1, 2]
# this is not destructive and can be checked by ensuring 'arr' has been mutated: p arr == [1, 2, 3, 4, 5]


# { a: 'ant', b: 'bear' }.map do |key, value|
#   if value.size > 3
#     value
#   end
# end

# map returns a new array containing the block's return value for each iteration, corresponding to each element.
# in this block, the if expression only returns a value if it evaluates to true, otherwise it returns nil.
# this map will return: [nil, 'bear']


# [1, 2, 3].map do |num|
#   if num > 1
#     puts num
#   else
#     num
#   end
# end

# this map returns a new array consisting of each element or nil.
# the if/then block returns nil if the element is greater than the integer 1, otherwise the else block returns the element
# this will return [1, nil, nil]

# frozen_string_literal: true

require_relative 'tictactoe_output'

WINNING_COMBINATIONS = [
  [1, 2, 3], [4, 5, 6], [7, 8, 9],
  [1, 4, 7], [2, 5, 8], [3, 6, 9],
  [1, 5, 9], [3, 5, 7]
]

def print_pause(text = nil, pause = 0)
  puts text unless text.nil?
  sleep pause unless pause.zero?
end

def player_text(human_condition, human_specific, computer_specific)
  if human_condition == BOARD_TEXT[:player]
    'You ' + human_specific
  else
    'Computer ' + computer_specific
  end
end

def start_game
  system CLEAR_CMD
  print_pause 'Welcome to Tic Tac Toe!'

  loop do
    play_til_five_wins
    break unless continue_game?
  end

  print_pause 'Thanks for playing Tic Tac Toe! Good bye!'
end

def continue_game?
  print_pause 'Play again? (y or n)'
  gets.chomp.downcase.start_with? 'y'
end

def play_til_five_wins
  scores = { BOARD_TEXT[:player] => 0, BOARD_TEXT[:computer] => 0 }
  last_winner = BOARD_TEXT[:player]

  until scores.value? 5
    last_winner = play_til_solved! scores, last_winner

    await_input unless scores.value? 5
  end

  text_beginning = player_text scores.key(5), 'have', 'has'
  print_pause "#{text_beginning} reached five wins."
end

def await_input
  print_pause "Press enter to continue..."
  gets
end

def play_til_solved!(scores, last_winner)
  board = [BOARD_TEXT[:empty]] * 9
  whos_turn = choose_first_turn last_winner, scores.keys
  print_game board, scores

  until winner?(board) || tie?(board)
    chosen_square = take_turn whos_turn, board
    board[chosen_square - 1] = whos_turn
    whos_turn = next_player whos_turn

    print_game board, scores
  end

  point_to_winner_or_nil!(board, scores) || last_winner
end

def choose_first_turn(who_decides, players)
  moving_first = players.sample

  if who_decides == BOARD_TEXT[:player]
    print_pause 'Do you want the first move? (y or n)'
    
    if gets.chomp.downcase.start_with? 'y'
      moving_first = BOARD_TEXT[:player]
    else
      moving_first = BOARD_TEXT[:computer]
    end
  end

  text_beginning = player_text moving_first, 'have', 'has'
  print_pause "#{text_beginning} the first move.", 0.5

  moving_first
end

def take_turn(whos_turn, board)
  available_squares = available_squares board

  if whos_turn == BOARD_TEXT[:player]
    print_pause 'Your turn...'

    player_select_square available_squares
  else
    print_pause nil, 0.25
    print_pause "Computer's turn...", 0.5

    computer_select_square available_squares, board
  end
end

def next_player(player)
  if player == BOARD_TEXT[:player]
    BOARD_TEXT[:computer]
  else
    BOARD_TEXT[:player]
  end
end

def available_squares(board)
  squares = board.each_index.map { |i| i + 1 }
  squares.select { |square| board[square - 1] == BOARD_TEXT[:empty] }
end

def winner?(board)
  [BOARD_TEXT[:player], BOARD_TEXT[:computer]].any? do |player|
    if won? board, player
      beginning_text = player_text player, 'are', 'is'
      print_pause "#{beginning_text} the winner!"

      true
    end
  end
end

def tie?(board)
  tied = board.none? BOARD_TEXT[:empty]
  print_pause "It's a tie!", 0.5 if tied

  tied
end

def point_to_winner_or_nil!(board, scores)
  winner = scores.keys.find { |player| won? board, player }
  scores[winner] += 1 unless winner.nil?
  winner
end

def won?(board, player)
  WINNING_COMBINATIONS.any? do |square_combination|
    square_combination.all? { |square| board[square - 1] == player }
  end
end

def player_select_square(empty_squares)
  square_selected = nil

  until empty_squares.include? square_selected
    print_pause "You chose an invalid square." unless square_selected.nil?
    print_pause "Choose a square to place a #{BOARD_TEXT[:player]}:"
    print_pause "(#{joinor empty_squares})"
    square_selected = gets.chomp[0].to_i
  end

  square_selected
end

def joinor(list, seperator = ', ', last = 'or')
  list = list.map { |square| color_text square.to_s, 'gray' }

  if list.length > 2
    list.insert(-2, last)
    list.join(seperator).sub! last + seperator, "#{last} "
  elsif list.length == 2
    list.join " #{last} "
  else
    list.first
  end
end
require 'pry'
def computer_select_square(empty_squares, board)
  return 5 if empty_squares.include? 5

  strategic_square = empty_squares.sample

  WINNING_COMBINATIONS.each do |square_combination|
    action = computer_action_and_square square_combination, empty_squares, board
    strategic_square = action.last unless action.empty?
    break if action.first == 'offensive'
  end

  strategic_square
end

def computer_action_and_square(square_combination, empty_squares, board)
  non_empty_squares = square_combination - empty_squares
  return [] if non_empty_squares == square_combination

  pieces_in_combination = non_empty_squares.map do |square|
    board[square - 1]
  end

  if pieces_in_combination.count(pieces_in_combination.first) == 2
    empty_square = (square_combination - non_empty_squares).first

    if pieces_in_combination.first == BOARD_TEXT[:computer]
      action = 'offensive'
    else
      action = 'defensive'
    end

    [action, empty_square]
  else
    []
  end
end

start_game

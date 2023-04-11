# frozen_string_literal: true

require_relative 'tictactoe_output'

WINNING_COMBINATIONS = [
  [1, 2, 3], [4, 5, 6], [7, 8, 9],
  [1, 4, 7], [2, 5, 8], [3, 6, 9],
  [1, 5, 9], [3, 5, 7]
].freeze

def print_pause(text = nil, pause = 0)
  puts text unless text.nil?
  sleep pause unless pause.zero?
end

def you_or_computer(player_text, computer_text, player_or_computer)
  if player_or_computer == BOARD_TEXT[:player]
    "You #{player_text}"
  else
    "Computer #{computer_text}"
  end
end

def yes_or_no?(question)
  loop do
    print_pause question
    answer = gets.chomp.downcase

    return true if %w(y ye yes yes. yes!).include? answer
    return false if %w(n no no. no!).include? answer
  end
end

def start_game
  system CLEAR_CMD
  print_pause 'Welcome to Tic Tac Toe!'
  print_pause 'The first to five wins is the winner.'

  loop do
    play_til_five_wins
    break unless yes_or_no? 'Play again? (y or n)'
  end

  print_pause 'Thanks for playing Tic Tac Toe! Good bye!'
end

def play_til_five_wins
  scores = { BOARD_TEXT[:player] => 0, BOARD_TEXT[:computer] => 0 }
  last_winner = BOARD_TEXT[:player]

  until scores.value? 5
    last_winner = play_til_solved! scores, last_winner

    await_input
  end

  system CLEAR_CMD
  text_beginning = you_or_computer 'have', 'has', scores.key(5)
  print_pause "#{text_beginning} reached five wins."
end

def await_input
  print_pause 'Press enter to continue...'
  gets
end

def play_til_solved!(scores, last_winner)
  board = [BOARD_TEXT[:empty]] * SQUARES_ACROSS**2
  whos_turn = choose_first_turn last_winner, scores.keys

  print_game board, scores

  until winner?(board) || board.none?(BOARD_TEXT[:empty])
    chosen_square = take_turn whos_turn, board
    board[chosen_square - 1] = whos_turn
    whos_turn = next_player whos_turn

    print_game board, scores
  end

  score_and_get_winner_or_nil!(board, scores) || last_winner
end

def choose_first_turn(who_decides, players)
  first_move = players.sample

  if who_decides == BOARD_TEXT[:player]
    player_first = yes_or_no? 'Do you want the first move? (y or n)'
    first_move = player_first ? BOARD_TEXT[:player] : BOARD_TEXT[:computer]
  end

  text_beginning = you_or_computer 'have', 'has', first_move
  print_pause "#{text_beginning} the first move.", 0.5

  first_move
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
    !winning_combination(board, player).nil?
  end
end

def score_and_get_winner_or_nil!(board, scores)
  winner = scores.keys.find do |player|
    !winning_combination(board, player).nil?
  end

  if winner
    scores[winner] += 1
    print_game board, scores, winning_combination(board, winner)

    beginning_text = you_or_computer 'are', 'is', winner
    print_pause "#{beginning_text} the winner!"
  else
    print_pause "It's a tie!"
  end

  winner
end

def winning_combination(board, player)
  WINNING_COMBINATIONS.find do |square_combination|
    square_combination.all? { |square| board[square - 1] == player }
  end
end

def player_select_square(empty_squares)
  square_selected = nil
  empty_squares_text = empty_squares.map(&:to_s)

  until empty_squares_text.include? square_selected
    print_pause 'You chose an invalid square.' unless square_selected.nil?
    print_pause "Choose a square to place a #{BOARD_TEXT[:player]}:"
    print_pause "(#{joinor empty_squares})"
    square_selected = gets.chomp
  end

  square_selected.to_i
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
  combination_pieces = non_empty_squares.map { |square| board[square - 1] }
  combination_piece = combination_pieces.first
  two_pieces = combination_pieces.length == 2
  return [] unless two_pieces && combination_pieces.all?(combination_piece)

  empty_square = (empty_squares & square_combination).first

  if combination_piece == BOARD_TEXT[:computer]
    ['offensive', empty_square]
  else
    ['defensive', empty_square]
  end
end

start_game

# frozen_string_literal: true

CLEAR_CMD = Gem.win_platform? ? 'cls' : 'clear'

SQUARES_ACROSS = 3
SQUARE_WIDTH = 5
SQUARE_HEIGHT = 3

CONNECTORS_COMBINATIONS = {
  '-' => [[1, 2, 3], [4, 5, 6], [7, 8, 9]],
  '|' => [[1, 4, 7], [2, 5, 8], [3, 6, 9]],
  '\\' => [[1, 5, 9]],
  '/' => [[3, 5, 7]]
}.freeze

CONNECTORS_OFFSETS = {
  '-' => [0, SQUARE_WIDTH / 2],
  '|' => [SQUARE_HEIGHT / 2, 0],
  '\\' => [SQUARE_HEIGHT / 2, SQUARE_WIDTH / 2],
  '/' => [SQUARE_HEIGHT / 2, -(SQUARE_WIDTH / 2)]
}.freeze

BOARD_TEXT = {
  player: 'X',
  computer: 'O',
  empty: ' ',
  horizontal: '-',
  vertical: '|',
  intersection: '+'
}.freeze

COLOR_SEQUENCES = {
  reset: "\e[m",
  red: "\e[31m",
  green: "\e[32m",
  gray: "\e[90m"
}.freeze

def color_text(text, color)
  fg_color = COLOR_SEQUENCES.fetch color.to_sym

  fg_color + text + COLOR_SEQUENCES[:reset]
end

PLAYER_HEADER = color_text 'You', 'green'
COMPUTER_HEADER = color_text 'Computer', 'red'

def new_output_board
  board = []

  ((SQUARE_HEIGHT * SQUARES_ACROSS) + 2).times do |row|
    board << []

    ((SQUARE_WIDTH * SQUARES_ACROSS) + 2).times do |col|
      board[row] << output_board_text(row, col)
    end

    board[row].freeze
  end

  board.freeze
end

# Input values represent indices (starting at 0)
# Constant values represent lengths, adding 1 aligns constant to input
def output_board_text(row, col)
  row_between_squares = ((row + 1) % (SQUARE_HEIGHT + 1)).zero?
  col_between_squares = ((col + 1) % (SQUARE_WIDTH + 1)).zero?

  if row_between_squares
    col_between_squares ? BOARD_TEXT[:intersection] : BOARD_TEXT[:horizontal]
  elsif col_between_squares
    BOARD_TEXT[:vertical]
  else
    BOARD_TEXT[:empty]
  end
end

OUTPUT_BOARD = new_output_board

def print_game(board, scores, winning_combination = nil)
  system CLEAR_CMD

  scores = scores.values.join ' : '
  output_scores = "#{PLAYER_HEADER} #{scores} #{COMPUTER_HEADER}"
  output_board = updated_output_board board, winning_combination

  puts [output_scores, '', output_board, '']
end

def updated_output_board(board, winning_combination = nil)
  output_board = OUTPUT_BOARD.map(&:dup)

  board.each_with_index do |piece, piece_index|
    output_row, output_col = output_board_row_col piece_index
    colored_text = piece_or_square_colored_text piece, piece_index + 1

    output_board[output_row][output_col] = colored_text
  end

  connect_combination! output_board, winning_combination

  output_board.map!(&:join)
end

def piece_or_square_colored_text(piece, square)
  if piece == BOARD_TEXT[:empty]
    color_text square.to_s, 'gray'
  else
    piece_color = piece == BOARD_TEXT[:player] ? 'green' : 'red'

    color_text piece, piece_color
  end
end

def connect_combination!(output_board, combination)
  return if combination.nil?

  connector = combinations_connector combination
  colored_connector = color_connector output_board, combination, connector
  offset_row_col = CONNECTORS_OFFSETS[connector]

  combination.each do |square|
    start_row_col = output_board_row_col(square - 1)
    connect! output_board, colored_connector, start_row_col, offset_row_col
  end
end

def combinations_connector(combination)
  CONNECTORS_COMBINATIONS.keys.select! do |connector|
    CONNECTORS_COMBINATIONS[connector].include? combination
  end.first
end

def color_connector(output_board, combination, connector)
  output_row, output_col = output_board_row_col(combination.first - 1)
  output_board_text = output_board[output_row][output_col]
  piece_is_player = output_board_text.include? BOARD_TEXT[:player]
  connector_color = piece_is_player ? 'green' : 'red'

  color_text connector, connector_color
end

def connect!(output_board, colored_connector, start_row_col, offset_row_col)
  output_row, output_col = start_row_col
  connector_row_offset, connector_col_offset = offset_row_col

  [1, -1].each do |i|
    connector_row = output_row + (i * connector_row_offset)
    connector_col = output_col + (i * connector_col_offset)

    output_board[connector_row][connector_col] = colored_connector
  end
end

# Constant values represent lengths, adding 1 aligns to the board's lines
# The minimum output is half/center of the first square
def output_board_row_col(board_piece_index)
  square_row = board_piece_index / SQUARES_ACROSS
  square_col = board_piece_index % SQUARES_ACROSS

  output_row_offset = (square_row * (SQUARE_HEIGHT + 1))
  output_row = (SQUARE_HEIGHT / 2) + output_row_offset
  output_col_offset = (square_col * (SQUARE_WIDTH + 1))
  output_col = (SQUARE_WIDTH / 2) + output_col_offset

  [output_row, output_col]
end

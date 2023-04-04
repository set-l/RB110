# frozen_string_literal: true

CLEAR_CMD = Gem.win_platform? ? 'cls' : 'clear'

def esc(n)
  "\e[#{n}m"
end

COLOR_SEQUENCES = {
  reset: esc(''),
  red: esc(31),
  green: esc(32),
  gray: esc(90)
}

def color_text(text, color)
  fg_color = COLOR_SEQUENCES.fetch color.to_sym

  fg_color + text + COLOR_SEQUENCES[:reset]
end

player_header = color_text 'You', 'green'
computer_header = color_text 'Computer', 'red'
SCOREBOARD_HEADER_TEXT = "#{player_header} : #{computer_header}"
BOARD_TEXT = {
  player: 'X',
  computer: 'O',
  placeholder: '$',
  empty: ' ',
  horizontal: '-',
  vertical: '|',
  intersection: '+'
}.freeze

def new_output_board
  empty = BOARD_TEXT[:empty]
  square = empty + BOARD_TEXT[:placeholder] + empty
  line = BOARD_TEXT[:horizontal] * 3

  ([''] * 5).each_with_index.map do |row_text, row_index|
    add = row_index.even? ? square : line
    optional = row_index.even? ? :vertical : :intersection

    3.times do |col_index|
      row_text += add
      row_text += BOARD_TEXT[optional] if col_index < 2
    end

    row_text
  end
end

OUTPUT_BOARD = new_output_board

def print_game(board, scores)
  system CLEAR_CMD

  scores = scores.values.join ' : '
  output_scores = SCOREBOARD_HEADER_TEXT.sub ':', scores
  output_game_ordered = [output_scores, '', print_board(board), '']
  # ordered_output.insert(-2, print_board(board))

  output_game_ordered.each { |text| puts text }
end

def print_board(board)
  board_square_index = -1

  OUTPUT_BOARD.map do |row_text|
    row_text.gsub BOARD_TEXT[:placeholder] do
      board_square_index += 1
      piece = board[board_square_index]

      color_piece piece, (board_square_index + 1)
    end
  end
end

def color_piece(piece, square)
  if piece == BOARD_TEXT[:empty]
    color_text square.to_s, 'gray'
  else
    human = piece == BOARD_TEXT[:player]
    piece_color = human ? 'green' : 'red'
    
    color_text piece, piece_color
  end
end

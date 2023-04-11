# return minimax board, 0, true

# def minimax(board, depth, maximizing_player)
#   available_squares = available_squares board
#   solved_value = minimax_value(board, available_squares) - depth
#   return solved_value unless solved_value.nil?

#   available_values = available_squares.map do |square|
#     child_board = board_next_move board, square, maximizing_player
#     minimax child_board, depth + 1, !maximizing_player
#   end

#   best_value = available_values.minmax[maximizing_player ? 1 : 0]
#   if depth.zero?
#     available_squares[available_values.index best_value]
#   else
#     best_value
#   end
# end

# def minimax_value(board, available_squares)
#   if won? board, BOARD_TEXT[:computer]
#     10
#   elsif won? board, BOARD_TEXT[:player]
#     -10
#   elsif available_squares(board).empty?
#     0
#   end
# end

# def board_next_move(board, square, maximizing_player)
#   child_board = board.dup
#   player = maximizing_player ? BOARD_TEXT[:computer] : BOARD_TEXT[:player]
#   child_board[square - 1] = player
#   child_board
# end

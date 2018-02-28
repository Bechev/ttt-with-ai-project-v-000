require 'pry'
module Players
  class Computer < Player

    def move(board)

      # We initialize a score_list to rate the possible moves that the computer can execute and perform the highest rated one
      scores = []
      # We identify the best move to make by assigning it a score. If the computer's next move gives him a win, he get 1 points
      #If it gives it a loss, he gets -1 point and if nothing, 0
      possible_moves = available_moves(board)

      #We verify if the next move can be a win and return if it is
      winning_move = winning_move?(possible_moves,board)
      if winning_move
        return (winning_move + 1).to_s
      end

      #We then check what are the moves that gives the most favorable outcomes
      score = 0
      scores = possible_moves.collect do |user_input|
        score_possible_move(board,user_input,self.token,score)
      end
      binding.pry
      (possible_moves[scores.each_with_index.max[1]]+1).to_s
    end


    def score_possible_move(board, move, token, score)
        #We copy the board we are received to not modify the original objects
        board_copy= duplicate_board(board)
        #binding.pry
        #We execute the move
        board_copy.cells[move] = token

        board_copy.cells.each do |cell|
          cell = token
          #We assess if the move executed give the computer a winning combination
          if board_copy.winning_board?
            if board_copy.game_winner? == self.token
              #case 1: it does and the computer gets one point
              score += 1
              return score
            else
              #case 2, it does not and the computer loses one point
              score -= 1
              return score
            end
          elsif board_copy.game_over?
            #case 3, the game is over, draw or win, or loose. We return the score associated with the move tried
            score += 0
            return score
          else
            #case 4, the game is not over and we iterate to the next move and we change the player
            token = token == "X" ? "O" : "X"
            list_of_moves = available_moves(board_copy)
            list_of_moves.each do |new_move|
              score_possible_move(board_copy, new_move, token, score)
            end
          end
        end
      end


      #We define the list of available moves to iterarte over them and get a score out of it
      def available_moves(board)
        available_moves =[]
        board.cells.each_with_index do |cell, index|
          if cell ==" "
            available_moves.push(index)
          end
        end
        available_moves
      end
      #end class & module

      def duplicate_board(board)
        board_copy= Marshal.load(Marshal.dump(board))
      end


      def winning_move?(possible_moves, board)
        #We try all immediate moves and see if they are winning.
        possible_moves.each do |move|
          #We refresh the board each time
          board_copy = duplicate_board(board)
          #We execute the move
          board_copy.cells[move] = self.token
          #We assess if it's a winning move and if so, returns the value
          if board_copy.winning_board?
            #binding.pry
            return move
            #binding.pry
          else
            return nil
          end
        end
      end

  end
end

require_relative 'connectors'

module Hipello
  class TrelloHandle
    attr_reader :boards, :list_ids, :last_added_card, :last_added_board, :errors
    include Connectors

    def initialize
      connect_to_trello
      load_boards
      @errors = []
    end

    def load_boards
      @boards = {}
      @list_ids = {}
      ENV.each do |key, value| 
        if m = key.to_s.upcase.match(/BOARD_ID_FOR_(.*)/)
          board = Trello::Board.find value
          @boards[m[1].downcase] = board

          # TODO move this
          list_id = board.lists.first.id
          @list_ids[m[1].downcase] = list_id
        end
      end
      @boards
    end

    def create_card_in(board_tag, card_options)
      @last_added_board = boards[board_tag]
      if l = list_ids[board_tag]
        @last_added_card = Trello::Card.create card_options.merge(list_id: l)
      else
        @errors.push("Require at least one list in board ##{board_tag} [#{@last_added_card.name}]")
      end
    end

    def show_boards
      boards.map{|board_tag, board| "##{board_tag} => [#{board.name}]"}.join(', ')
    end

    def display_errors
      @errors.to_sentence
    end

    def valid?
      @errors.empty?
    end
  end
end

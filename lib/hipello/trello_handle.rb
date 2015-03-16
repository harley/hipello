require_relative 'connectors'

module Hipello
  class TrelloHandle
    attr_reader :boards, :list_ids
    include Connectors

    def initialize
      connect_to_trello
      load_boards
    end

    def load_boards
      @boards = {}
      @list_ids = {}
      ENV.each do |key, value| 
        if m = key.to_s.upcase.match(/BOARD_FOR_ID_(.*)/)
          board = Trello::Board.find value
          list_id = board.lists.first.id
          @boards[m[1].downcase] = board
          @list_ids[m[1].downcase] = list_id
        end
      end
      @boards
    end

    def add_card_to(board_tag, card_name)
      if l = @list_ids[board_tag]
        Trello::Card.create list_id: l.id, name: card_name
      else
        raise "List doesn't exist"
      end
    end
  end
end

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
      if l = list_ids[board_tag]
        card = Trello::Card.create card_options.merge(list_id: l)
      else
        raise "List doesn't exist"
      end
    end
  end
end

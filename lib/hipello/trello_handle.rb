require_relative 'connectors'

module Hipello
  class TrelloHandle
    attr_reader :board, :lists, :lookup
    include Connectors

    def initialize
      connect_to_trello
      find_board
      @lookup = {}
      @lists.each do |l|
        @lookup[l.name] = l
      end
    end

    def find_board
      @board = Trello::Board.find ENV['TRELLO_BOARD_ID']
      @lists = @board.lists
      @board
    end

    def add_card(name)
      ListCard.mine.create_card(name)
    end

    def add_card_to(list_name, card_name)
      if l = lookup[list_name]
        Trello::Card.create list_id: l.id, name: card_name
      else
        raise "List doesn't exist"
      end
    end
  end
end

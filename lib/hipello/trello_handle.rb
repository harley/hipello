require_relative 'connectors'

module Hipello
  class TrelloHandle
    attr_reader :boards, :list_ids, :last_added_card, :last_added_board, :errors, :last_message
    include Connectors
    include Singleton

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
      @errors = []
      @last_added_board = boards[board_tag]
      if l = list_ids[board_tag]
        if card_options[:name].present?
          @last_added_card = Trello::Card.create card_options.merge(list_id: l)
          # TODO: catch API call crashing
        else
          @errors.push("I need some text to add a card to board ##{board_tag} [#{@last_added_card.name}]")
        end
      else
        @errors.push("I need at least one list in board ##{board_tag} [#{@last_added_card.name}]")
      end
      self
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

    def clear_errors!
      @errors = []
    end

    def self.add_card(board_tag, card_options)
      instance.create_card_in(board_tag, card_options)
    end
  end
end

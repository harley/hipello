require_relative 'connectors'

module Hipello
  class TrelloHandle
    attr_reader :boards, :board_lists, :board_inbox, :errors, :board_members
    attr_reader :current_card, :current_board, :current_list, :last_message
    include Connectors
    include Singleton

    def initialize
      connect_to_trello
      load_boards
      @errors = []
    end

    def load_boards
      @boards = {}
      @board_lists = {}
      @board_inbox = {}
      @board_members = {}
      ENV.each do |key, value| 
        if m = key.to_s.upcase.match(/BOARD_ID_FOR_(.*)/)
          tag = m[1].downcase

          board = Trello::Board.find value
          @boards[tag] = board

          # TODO move this
          @board_lists[tag] = board.lists
          @board_inbox[tag] = find_inbox_in(board.lists)
          board.members.each do |member|
            @board_members[member.username] = member
          end
        end
      end
      @boards
    end

    def valid_tags
      boards.keys.map{|e| "#" + e} * ', '
    end

    def find_inbox_in(lists)
      lists.find {|e| e.name.match(/inbox/i)} || lists[0]
    end

    def create_card_in(mentions: [], hashtag:, sender:, title:, description: '')
      description << "\n-- asked by #{sender}"
      members = mentions.map{|u| board_members[u]}.compact.uniq
      # puts "[INSPECT] MENTIONS: #{mentions.inspect}"
      # puts "[INSPECT] MEMBERS: #{members.inspect}"

      card_options = {name: title, desc: description}
      card_options.merge! member_ids: members.map(&:id)

      @errors = []
      if @current_board = boards[hashtag]
        if @current_list = board_inbox[hashtag]
          if card_options[:name].present?
            @current_card = Trello::Card.create card_options.merge(list_id: @current_list.id)
          else
            @errors.push("I need text to add a card to board ##{hashtag} [#{@current_board.name}]")
          end
        else
          @errors.push("Is the board ##{hashtag} [#{@current_board.name}] empty? I need at least list.")
        end
      else
        @errors.push("(to create a Trello card, use one of: #{valid_tags})")
      end
      self
    end

    def show_boards
      boards.map{|hashtag, board| "##{hashtag} => [#{board.name}]"}.join(', ')
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

    def self.add_card(options)
      instance.create_card_in(options)
    end
  end
end

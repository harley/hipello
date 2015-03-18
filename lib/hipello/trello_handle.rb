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

    def find_inbox_in(lists)
      lists.find {|e| e.name.match(/inbox/i)} || lists[0]
    end

    def create_card_in(mentions: [], board_tag:, sender:, title:, description: '')
      description << "\n-- asked by #{sender}"
      puts "\n\n\nMENTIONS: #{mentions.inspect}"
      members = mentions.map{|u| board_members[u]}.compact.uniq
      puts "\n\n\nMEMBERS: #{members.inspect}"

      card_options = {name: title, desc: description}
      card_options.merge! member_ids: members.map(&:id)

      @errors = []
      @current_board = boards[board_tag]
      if @current_list = board_inbox[board_tag]
        if card_options[:name].present?
          @current_card = Trello::Card.create card_options.merge(list_id: @current_list.id)
          # TODO: catch API call crashing
        else
          @errors.push("I need card title text to add to board ##{board_tag} [#{@current_board.name}]")
        end
      else
        @errors.push("I need at least one list in board ##{board_tag} [#{@current_board.name}]")
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

    def self.add_card(options)
      instance.create_card_in(options)
    end
  end
end

require_relative 'connectors'

module Hipello
  class TrelloHandle
    attr_reader :boards, :board_lists, :board_inbox, :board_members, :username_mapping
    attr_reader :current_card, :current_board, :current_list, :last_message, :errors
    include Connectors
    include Singleton

    def initialize
      connect_to_trello
      load_boards
      load_username_mapping
      @errors = []
      # puts "\n\n\n[INSPECT] USERNAMES: #{username_mapping.inspect}"
      # puts "\n\n\n[INSPECT] BOARD_MEMBERS: #{board_members.inspect}"
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
            # normalize by downsizing
            @board_members[member.username.downcase] = member
          end
        end
      end
      @boards
    end

    def load_username_mapping
      @username_mapping = {}
      if raw = ENV['HIPCHAT_TO_TRELLO_USERNAMES']
        raw.split(';').each do |s|
          hipchat_u, trello_u = *s.split(':')
          @username_mapping[hipchat_u] = trello_u
        end
      end
      @username_mapping
    end

    def valid_tags
      boards.keys.map{|e| "#" + e} * ', '
    end

    def find_inbox_in(lists)
      lists.find {|e| e.name.match(/inbox/i)} || lists[0]
    end

    def locate_member(hipchat_username)
      if member = member_in_board(hipchat_username)
        member
      elsif trello_username = username_mapping[hipchat_username]
        member_in_board(trello_username)
      end
    end

    def member_in_board(username)
        board_members[username.downcase]
    end

    def create_card_in(mentions: [], hashtag:, sender:, title:, description: '')
      description << "\n-- added by #{sender} from Hipchat"
      members = mentions.uniq.map{|u| locate_member(u)}.compact
      # puts "\n\n\n[INSPECT] MENTIONS: #{mentions.inspect}"
      # puts "\n\n\n[INSPECT] LOCATED MEMBERS: #{members.inspect}"

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

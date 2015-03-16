require 'trello'
require 'hipbot'
require 'hipbot-plugins/human'
require_relative 'hipello/trello_handle'
require_relative 'hipello/hipchat_handle'
require_relative 'hipello/message_parser'

# TODO move into lib/hipello
module Hipello
  class MyHipbot < Hipbot::Bot
    desc 'this is a simple response'
    on(/hello/) do
      reply('hello human')
    end

    on(/(.+)/, global: true) do |text|
      if text.match(/#\w+/)
        @trello = MyHipbot.ask_trello(text)
        if @trello.valid?
          reply("added card '#{@trello.last_added_card.name}' to board '#{@trello.last_added_board.name}'")
        else
          reply(@trello.display_errors)
        end
      end
    end

    def self.ask_trello(text)
      output = MessageParser.new(text).output
      board_tag = output[:hashtag]
      raise "board tag is missing" unless board_tag.present?
      title = output[:title]
      raise "title is missing" unless title.present?

      @handle ||= TrelloHandle.new
      @handle.create_card_in(board_tag, name: title)
      @handle
    end
  end
end

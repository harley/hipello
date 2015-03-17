require 'trello'
require 'hipbot'
require_relative 'hipello/trello_handle'
require_relative 'hipello/hipchat_handle'
require_relative 'hipello/message_parser'

# TODO move into lib/hipello
module Hipello
  class MyHipbot < Hipbot::Bot
    on(/(.*)#(\w+)(.*)/, global: true) do |beforetag, hashtag, aftertag|
      text = beforetag + aftertag
      begin
        @trello = MyHipbot.ask_trello(text, hashtag)
        if @trello.valid?
          reply("added card '#{@trello.current_card.name}' to list '#{@trello.current_list.name}' in board '#{@trello.current_board.name}'")
        else
          reply(@trello.display_errors)
        end
      rescue Exception => e
        reply(e)
        raise(e)
      end
    end

    def self.ask_trello(text, hashtag = nil)
      output = MessageParser.new(text, hashtag).output
      board_tag = output[:hashtag]
      raise "trying to connect to Trello but board hashtag is missing" unless board_tag.present?
      title = output[:title]
      raise "creating a Trello card? I need some text for the name" unless title.present?

      TrelloHandle.add_card(board_tag, name: title)
    end
  end
end

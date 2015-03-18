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
        @trello = MyHipbot.ask_trello(sender, text, hashtag)
        if @trello.valid?
          reply("added card '#{@trello.current_card.name}' to list '#{@trello.current_list.name}' in board '#{@trello.current_board.name}'")
        else
          reply(@trello.display_errors)
        end
      rescue Exception => e
        reply("ERROR: #{e}")
        raise(e)
      end
    end

    def self.ask_trello(sender, text, hashtag = nil)
      output = MessageParser.new(text, hashtag).output
      TrelloHandle.add_card(output.merge(sender: sender))
    end
  end
end

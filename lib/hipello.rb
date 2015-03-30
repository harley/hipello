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
        @trello = MyHipbot.ask_trello(room, sender, text, hashtag)
        if @trello.valid?
          reply("added \"#{@trello.current_card.name[0..5]}…\" to [#{@trello.current_list.name}] in {#{@trello.current_board.name}} #{@trello.current_card.short_url}")
        else
          reply(@trello.display_errors)
        end
        # reply "\n\n\nROOM: #{room.inspect}"
      rescue Exception => e
        reply("ERROR: #{e}")
        raise(e)
      end
    end

    def self.ask_trello(room, sender, text, hashtag = nil)
      output = MessageParser.new(text, hashtag).output
      TrelloHandle.add_card(output.merge(sender: sender, room: room))
    end
  end
end

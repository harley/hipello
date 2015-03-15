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

    on(/trello (.+)/) do |name|
      @list_card = ListCard.mine
      @list_card.create_card(name)
    end
  end

  class ListCard
    attr_reader :list_id

    def initialize(list_id)
      @list_id = list_id
    end

    def create_card(name)
      if name.present?
        Trello::Card.create list_id: @list_id, name: name
      end
    end

    def self.mine
      new(ENV['TRELLO_LIST_ID'])
    end
  end
end

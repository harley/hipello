require 'trello'
require 'hipbot'
require 'hipbot-plugins/human'

# TODO move into lib/hipello
module Hipello
  module Connectors
    def connect_to_trello
      Trello.configure do |config|
        config.developer_public_key = ENV['TRELLO_KEY']  # The "key" from step 1
        config.member_token = ENV['TRELLO_MEMBER_TOKEN'] # The token from step 3.
      end
    end
    def connect_to_hipchat
      Hipello::MyHipbot.configure do |config|
        config.jid       = ENV['HIPBOT_JID']
        config.password  = ENV['HIPBOT_PASSWORD']
        fail "Define HIPBOT_JID and HIPBOT_PASSWORD env variables!" unless config.jid && config.password
      end
    end
  end

  class TrelloHandler
    include Connectors

    def initialize
      connect_to_trello
    end

    def add_card(name)
      ListCard.mine.create_card(name)
    end
  end

  class HipchatHandler
    include Connectors
    def initialize
      connect_to_hipchat
    end

    def test_start!
      MyHipbot.start!
    end
  end

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

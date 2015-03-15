module Hipello
  module Connectors
    def connect_to_trello
      Trello.configure do |config|
        config.developer_public_key = ENV['TRELLO_KEY']  # The "key" from step 1
        config.member_token = ENV['TRELLO_MEMBER_TOKEN'] # The token from step 3.
        fail "Define TRELLO_KEY and TRELLO_MEMBER_TOKEN env variables!" unless config.developer_public_key && config.member_token
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
end

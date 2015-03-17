require_relative 'connectors'

module Hipello
  class HipchatHandle
    include Connectors
    def initialize
      connect_to_hipchat
    end

    def start_bot!
      MyHipbot.start!
    end
  end
end

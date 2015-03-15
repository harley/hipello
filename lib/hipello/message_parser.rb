module Hipello
  class MessageParser
    attr_reader :text, :output

    def initialize(text)
      @text = text
      @output = {
        mentions: [],
        hashtag: '', # only allow one hash tag
        title: '',
        description: ''
      }
    end

    def parse
    end
  end
end

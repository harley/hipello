module Hipello
  class MessageParser
    MENTION = /(@\w+)/
    HASHTAG = /#([^ ]+)/
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
      if m = text.match(MENTION)
        @output[:mentions].push m[0]
      end

      if m = text.match(HASHTAG)
        @output[:hashtag]  = m[1]
      end

      message = text.gsub(MENTION, '').gsub(HASHTAG, '').squeeze.strip
      @output[:title] = message
    end

    def mentions
      @output[:mentions]
    end

    def hashtag
      @output[:hashtag]
    end

    def title
      @output[:title]
    end
  end
end

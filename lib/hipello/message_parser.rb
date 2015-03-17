module Hipello
  class MessageParser
    MENTION = /(@\w+)/
    HASHTAG = /#([^ ]+)/
    attr_reader :text, :output

    def initialize(text, hashtag = nil)
      @text = text
      @output = {
        mentions: [],
        hashtag: hashtag, # only allow one hash tag
        title: '',
        description: ''
      }
      parse
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

    private

    def parse
      message = text.dup

      while m = message.match(MENTION) do
        @output[:mentions].push m[1]
        message.sub!(MENTION, '')
      end

      if @output[:hashtag].nil? && (m = message.match(HASHTAG))
        @output[:hashtag] = m[1]
        message.gsub!(HASHTAG, '')
      end

      message = message.strip.squeeze # remove double spaces caused by deleting words

      @output[:title] = message
      @output
      self
    end
  end
end

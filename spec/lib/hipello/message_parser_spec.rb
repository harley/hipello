require 'spec_helper'

describe "MessageParser" do
  it "should parse a basic example correctly" do
    @parser = Hipello::MessageParser.new "hey @greg can you take the trash out #request"
    @parser.parse
    expect(@parser.mentions).to eq ["@greg"]
    expect(@parser.hashtag).to eq "request"
    expect(@parser.title).to eq "hey can you take the trash out"
  end
end

require 'spec_helper'

describe "MessageParser" do
  it "should parse a basic example correctly" do
    @parser = Hipello::MessageParser.new "hey @greg can you take the trash out #request"
    expect(@parser.mentions).to eq ["@greg"]
    expect(@parser.hashtag).to eq "request"
    expect(@parser.title).to eq "hey can you take the trash out"
  end

  context "empty message" do
  end

  context "multiple mentions" do
  end

  context "multiple sentences" do
  end
end

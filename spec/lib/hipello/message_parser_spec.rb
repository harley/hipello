require 'spec_helper'

describe "MessageParser" do
  let(:parser) { Hipello::MessageParser.new @message }
  it "should parse a basic example correctly" do
    @message = "hey @greg can you take the trash out #request"
    expect(parser.mentions).to eq ["greg"]
    expect(parser.hashtag).to eq "request"
    expect(parser.title).to eq "hey can you take the trash out"
  end

  context "empty message" do
    it "should parse correctly" do
      @message = ""
      expect(parser.mentions).to eq []
      expect(parser.hashtag).to eq nil
      expect(parser.title).to eq ''
    end
  end

  context "multiple mentions" do
    it "should find all mentions" do
      @message = "@bike is faster than @car"
      expect(parser.mentions).to eq ["bike", "car"]
    end
  end

  context "multiple sentences" do
  end
end

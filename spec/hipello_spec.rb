require 'spec_helper'

describe Hipello::MyHipbot do
  let(:board1) { instance_double('Board', lists: [list1], name: 'board 1', members: [member1]) }
  let(:board2) { instance_double('Board', lists: [list2, inbox], name: 'board 2', members: [member1]) }
  let(:list1)  { instance_double('List', name: 'list-1', id: '111') }
  let(:list2)  { instance_double('List', name: 'list-2', id: '222') }
  let(:inbox)  { instance_double('List', name: 'Inbox', id: '333')  }
  let(:member1){ instance_double('Member', id: 'abc123', username: 'xyz')}
  let(:sender) { instance_double('Hipchat User')}

  describe "#ask_trello" do
    it "should raise error for missing title" do
      allow(Hipello::TrelloHandle).to receive(:add_card)
      expect{Hipello::MyHipbot.ask_trello(sender, 'abc')}.to raise_error(/hashtag is missing/)
      expect{Hipello::MyHipbot.ask_trello(sender, '', '#tag')}.to raise_error(/I need some text/)
      expect{Hipello::MyHipbot.ask_trello(sender, 'abc', '#tag')}.to_not raise_error
    end
  end
end

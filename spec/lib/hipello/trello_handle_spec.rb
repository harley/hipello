require 'spec_helper'

describe Hipello::TrelloHandle do
  let(:board1) { instance_double('Board', lists: [list1], name: 'board 1', members: [member1]) }
  let(:board2) { instance_double('Board', lists: [list2, inbox], name: 'board 2', members: [member1]) }
  let(:list1)  { instance_double('List', name: 'list-1', id: '111') }
  let(:list2)  { instance_double('List', name: 'list-2', id: '222') }
  let(:inbox)  { instance_double('List', name: 'Inbox', id: '333')  }
  let(:member1){ instance_double('Member', id: 'abc123', username: 'xyz')}
  let(:sender) { instance_double('Hipchat User')}

  let(:handle) { Class.new(Hipello::TrelloHandle).instance } # reset the instance at each test

  before do
    ENV['BOARD_ID_FOR_REQUEST'] = 'abc123'
    ENV['BOARD_ID_FOR_BUG'] = 'xyz123'

    allow(Trello::Board).to receive(:find) do |val|
      case val
      when 'abc123'
        board1
      when 'xyz123'
        board2
      end
    end
    # allow(Trello::Board).to receive(:find).with('abcxyz') { board2 }
    allow_any_instance_of(Hipello::TrelloHandle).to receive(:connect_to_trello)
  end

  describe "#new" do
    it "should reload the right boards" do
      expect(handle.boards).to eq({'request' => board1, 'bug' => board2})
      expect(handle.board_lists).to eq({'request' => [list1], 'bug' => [list2, inbox]})
      expect(handle.board_inbox).to eq({'request' => list1, 'bug' => inbox})
    end
  end

  describe "#create_card_in" do
    it "should add to the right board" do
      card = instance_double('Card')
      allow(Trello::Card).to receive(:create) { card }
      expect{handle.create_card_in(board_tag: 'request', sender: sender, title: 'card1')}.to change {handle.current_card}.to(card)
    end
  end

  describe "#show_boards" do
    it "should display correctly" do
      expect(handle.show_boards).to eq "#request => [board 1], #bug => [board 2]"
    end
  end
end

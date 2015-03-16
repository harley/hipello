require 'spec_helper'

describe 'Trello::TrelloHandle' do
  let(:board1) { instance_double('Board 1', lists: [list1], name: 'board 1') }
  let(:board2) { instance_double('Board 2', lists: [list2], name: 'board 2') }
  let(:list1)  { instance_double('List1', name: 'list-1', id: '111') }
  let(:list2)  { instance_double('List2', name: 'list-2', id: '222') }
  let(:handle) { Class.new(Hipello::TrelloHandle).instance } # want to reset the instance at each test

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

  describe "#board" do
    it "should reload the right boards" do
      expect(handle.boards).to eq({'request' => board1, 'bug' => board2})
      expect(handle.list_ids).to eq({'request' => '111', 'bug' => '222'})
    end
  end

  describe "#create_card_in" do
    it "should add to the right board" do
      card = instance_double('Card')
      allow(Trello::Card).to receive(:create) { card }
      expect{handle.create_card_in('request', name: 'card1')}.to change {handle.last_added_card}.to(card)
    end
  end

  describe "#show_boards" do
    it "should display correctly" do
      expect(handle.show_boards).to eq "#request => [board 1], #bug => [board 2]"
    end
  end
end

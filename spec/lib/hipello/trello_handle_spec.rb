require 'spec_helper'

describe 'Trello::TrelloHandle' do
  let(:board1) { instance_double('Board 1', lists: [list1]) }
  let(:board2) { instance_double('Board 2', lists: [list2]) }
  let(:list1)  { instance_double('List1', name: 'list-1', id: '111') }
  let(:list2)  { instance_double('List2', name: 'list-2', id: '222') }
  let(:handle) { Hipello::TrelloHandle.new }

  before do
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

    ENV['BOARD_ID_FOR_REQUEST'] = 'abc123'
    ENV['BOARD_ID_FOR_BUG'] = 'xyz123'
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
      expect(handle.create_card_in('request', name: 'card1')).to eq card
    end
  end
end

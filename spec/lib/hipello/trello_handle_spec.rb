require 'spec_helper'

describe 'Trello::TrelloHandle' do
  describe "#new" do
    let(:board1) { instance_double('Board 1', lists: [list1]) }
    let(:board2) { instance_double('Board 2', lists: [list2]) }
    let(:list1) {  instance_double('List1', name: 'list-1', id: 1) }
    let(:list2) {  instance_double('List2', name: 'list-2', id: 2) }

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
    end

    it "should call certain methods" do
      ENV['BOARD_FOR_ID_REQUEST'] = 'abc123'
      ENV['BOARD_FOR_ID_BUG'] = 'xyz123'
      @handle = Hipello::TrelloHandle.new
      expect(@handle.boards).to eq({'request' => board1, 'bug' => board2})
    end
  end
end

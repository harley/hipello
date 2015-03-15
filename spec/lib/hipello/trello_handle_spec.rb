require 'spec_helper'

describe 'Trello::TrelloHandle' do
  describe "#new" do
    let(:board) { instance_double('Board', lists: [list]) }
    let(:list) {  instance_double('List', name: 'list-1') }
    before do
      allow(Trello::Board).to receive(:find) { board }
      allow_any_instance_of(Hipello::TrelloHandle).to receive(:connect_to_trello)
    end

    it "should call certain methods" do
      @handle = Hipello::TrelloHandle.new
      expect(@handle.board).to eq board
      expect(@handle.lists).to eq [list]
      expect(@handle.lookup).to eq({'list-1' => list })
    end
  end
end

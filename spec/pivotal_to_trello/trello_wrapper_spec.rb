require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

describe 'TrelloWrapper' do
  let(:wrapper) { PivotalToTrello::TrelloWrapper.new('key', 'token') }

  before(:each) do
    allow_any_instance_of(IO).to receive(:puts)
  end

  context '#initialize' do
    it 'sets the auth credentials' do
      config = double
      expect(Trello).to receive(:configure).and_yield(config)
      expect(config).to receive(:developer_public_key=).with('key')
      expect(config).to receive(:member_token=).with('token')
      PivotalToTrello::TrelloWrapper.new('key', 'token')
    end
  end

  context '#create_card' do
    let(:card) { mock_trello_card }

    it 'creates a new card if none exists' do
      story = mock_pivotal_story
      expect(wrapper).to receive(:get_card).and_return(nil)
      expect(Trello::Card).to receive(:create).with(
        name:    story.name,
        desc:    story.description,
        list_id: 'list_id',
      ).and_return(card)
      expect(wrapper.create_card('list_id', story)).to eq(card)
    end

    it 'does not create a new card if one exists with the same name' do
      story = mock_pivotal_story(name: 'My Card')
      allow(Trello::List).to receive_message_chain(:find, :cards).and_return([card])
      expect(Trello::Card).not_to receive(:create)
      expect(wrapper.create_card('list_id', story)).to eq(card)
    end

    it 'creates a new card if one exists with a different name' do
      story = mock_pivotal_story(name: 'My Foo')
      allow(Trello::List).to receive_message_chain(:find, :cards).and_return([card])
      expect(Trello::Card).to receive(:create).with(
        name:    story.name,
        desc:    story.description,
        list_id: 'list_id',
      ).and_return(card)
      expect(wrapper.create_card('list_id', story)).to eq(card)
    end

    it 'adds comments' do
      note  = OpenStruct.new(text: 'My Note')
      story = mock_pivotal_story
      allow(story).to receive(:comments).and_return([note])
      expect(wrapper).to receive(:get_card).and_return(nil)
      expect(Trello::Card).to receive(:create).and_return(card)
      expect(card).to receive(:add_comment).with('My Note')
      expect(wrapper.create_card('list_id', story)).to eq(card)
    end

    it 'adds tasks' do
      task      = OpenStruct.new(description: 'My Task', complete: false)
      story     = mock_pivotal_story
      checklist = double(Trello::Checklist)
      allow(story).to receive(:tasks).and_return([task])
      expect(wrapper).to receive(:get_card).and_return(nil)
      expect(Trello::Card).to receive(:create).and_return(card)
      expect(Trello::Checklist).to receive(:create).with(name: 'Tasks', card_id: card.id).and_return(checklist)
      expect(card).to receive(:add_checklist).with(checklist)
      expect(checklist).to receive(:add_item).with(task.description, task.complete)
      expect(wrapper.create_card('list_id', story)).to eq(card)
    end
  end

  context '#board_choices' do
    it 'returns a hash of Trello boards' do
      board = OpenStruct.new(id: 'id', name: 'My Board')
      expect(Trello::Board).to receive(:all).and_return([board])
      expect(wrapper.board_choices).to eq('id' => 'My Board')
    end
  end

  context '#list_choices' do
    it 'returns a hash of Trello lists' do
      board = double(Trello::Board)
      list  = OpenStruct.new(id: 'id', name: 'My List')
      expect(Trello::Board).to receive(:find).with('board_id').and_return(board)
      expect(board).to receive(:lists).and_return([list])
      expect(wrapper.list_choices('board_id')).to eq( 'id'  => 'My List',
                                                      false => "[don't import these stories]")
    end
  end

  context '#cards_for_list' do
    it 'returns a hash of Trello lists' do
      list = double(Trello::List)
      card = OpenStruct.new(name: 'My Card', desc: 'My Description')
      expect(Trello::List).to receive(:find).with('list_id').and_return(list)
      expect(list).to receive(:cards).and_return([card])
      expected = { '193060beddd00d64259bdc1271d6c5a330e92e7d' => card }
      expect(wrapper.cards_for_list('list_id')).to eq(expected)
      # Test caching.
      expect(Trello::List).not_to receive(:find)
      expect(wrapper.cards_for_list('list_id')).to eq(expected)
    end
  end

  context '#add_label' do
    let(:board) { double(Trello::Board) }

    before do
      expect(Trello::Board).to receive(:find).with('board_id').and_return(board)
      allow(board).to receive(:labels).and_return([])
    end

    it 'adds a label if it does not already exist' do
      label = double(Trello::Label)
      card  = mock_trello_card(board_id: 'board_id')
      allow(card).to receive_messages(labels: [])
      expect(Trello::Label).to receive(:create).with(name: 'bug', board_id: 'board_id', color: 'red').and_return(label)
      expect(card).to receive(:add_label).with(label)
      wrapper.add_label(card, 'bug', 'red')
    end

    it 'does not add a label if it already exists' do
      label = double(Trello::Label, id: '1234', name: 'bug', color: 'red')
      card  = mock_trello_card(board_id: 'board_id')
      allow(board).to receive(:labels).and_return([label])
      allow(card).to receive_messages(labels: [label])
      expect(card).not_to receive(:add_label)
      wrapper.add_label(card, 'bug', 'red')
    end
  end

end

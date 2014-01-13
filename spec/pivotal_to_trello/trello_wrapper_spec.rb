require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

describe 'TrelloWrapper' do
  let(:wrapper) { PivotalToTrello::TrelloWrapper.new('key', 'token') }

  before(:each) do
    IO.any_instance.stub(:puts)
  end

  context '#initialize' do
    it 'sets the auth credentials' do
      config = double
      Trello.should_receive(:configure).and_yield(config)
      config.should_receive(:developer_public_key=).with('key')
      config.should_receive(:member_token=).with('token')
      PivotalToTrello::TrelloWrapper.new('key', 'token')
    end
  end

  context '#create_card' do
    let(:card) { mock_trello_card }

    it 'creates a new card if none exists' do
      story = mock_pivotal_story
      wrapper.should_receive(:get_card).and_return(nil)
      Trello::Card.should_receive(:create).with(
        :name    => story.name,
        :desc    => story.description,
        :list_id => 'list_id'
      ).and_return(card)
      wrapper.create_card('list_id', story).should == card
    end

    it 'does not create a new card if one exists with the same name' do
      story = mock_pivotal_story(:name => 'My Card')
      Trello::List.stub_chain(:find, :cards).and_return([card])
      Trello::Card.should_not_receive(:create)
      wrapper.create_card('list_id', story).should == card
    end

    it 'creates a new card if one exists with a different name' do
      story = mock_pivotal_story(:name => 'My Foo')
      Trello::List.stub_chain(:find, :cards).and_return([card])
      Trello::Card.should_receive(:create).with(
        :name    => story.name,
        :desc    => story.description,
        :list_id => 'list_id'
      ).and_return(card)
      wrapper.create_card('list_id', story).should == card
    end

    it 'adds comments' do
      note  = OpenStruct.new(:text => 'My Note', :author => 'John Smith')
      story = mock_pivotal_story
      story.stub_chain(:notes, :all).and_return([note])
      wrapper.should_receive(:get_card).and_return(nil)
      Trello::Card.should_receive(:create).and_return(card)
      card.should_receive(:add_comment).with('[John Smith] My Note')
      wrapper.create_card('list_id', story).should == card
    end
  end

  context '#board_choices' do
    it 'returns a hash of Trello boards' do
      board = OpenStruct.new(:id => 'id', :name => 'My Board')
      Trello::Board.should_receive(:all).and_return([board])
      wrapper.board_choices.should == { 'id' => 'My Board'}
    end
  end

  context '#list_choices' do
    it 'returns a hash of Trello lists' do
      board = double(Trello::Board)
      list  = OpenStruct.new(:id => 'id', :name => 'My List')
      Trello::Board.should_receive(:find).with('board_id').and_return(board)
      board.should_receive(:lists).and_return([list])
      wrapper.list_choices('board_id').should == {
        'id'  => 'My List',
        false => "[don't import these stories]",
      }
    end
  end

  context '#cards_for_list' do
    it 'returns a hash of Trello lists' do
      list = double(Trello::List)
      card  = OpenStruct.new(:name => 'My Card', :desc => 'My Description')
      Trello::List.should_receive(:find).with('list_id').and_return(list)
      list.should_receive(:cards).and_return([card])
      expected = {'193060beddd00d64259bdc1271d6c5a330e92e7d' => card}
      wrapper.cards_for_list('list_id').should == expected
      # Test caching.
      Trello::List.should_not_receive(:find)
      wrapper.cards_for_list('list_id').should == expected
    end
  end

  context '#add_label' do
    it 'adds a label if it does not already exist' do
      card = mock_trello_card
      card.stub(:labels => [])
      card.should_receive(:add_label).with('red')
      wrapper.add_label(card, 'red')
    end

    it 'does not add a label if it already exists' do
      card = mock_trello_card
      card.stub(:labels => [OpenStruct.new(:color => 'red')])
      card.should_not_receive(:add_label)
      wrapper.add_label(card, 'red')
    end
  end

end
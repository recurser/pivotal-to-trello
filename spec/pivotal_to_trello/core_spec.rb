require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

describe 'Core' do
  let(:core)    { PivotalToTrello::Core.new(mock_options) }
  let(:pivotal) { mock_pivotal_wrapper }
  let(:trello)  { mock_trello_wrapper }

  before(:each) do
    IO.any_instance.stub(:puts)
    core.stub(:pivotal => pivotal)
    core.stub(:trello  => trello)

    core.stub(:prompt_selection).with('Which Pivotal project would you like to export?', pivotal.project_choices).and_return('pivotal_project_id')
    core.stub(:prompt_selection).with('Which Trello board would you like to import into?', trello.board_choices).and_return('trello_board_id')
    core.stub(:prompt_selection).with("Which Trello list would you like to put 'icebox' stories into?", trello.list_choices).and_return('icebox_list_id')
    core.stub(:prompt_selection).with("Which Trello list would you like to put 'current' stories into?", trello.list_choices).and_return('current_list_id')
    core.stub(:prompt_selection).with("Which Trello list would you like to put 'finished' stories into?", trello.list_choices).and_return('finished_list_id')
    core.stub(:prompt_selection).with("Which Trello list would you like to put 'delivered' stories into?", trello.list_choices).and_return('delivered_list_id')
    core.stub(:prompt_selection).with("Which Trello list would you like to put 'accepted' stories into?", trello.list_choices).and_return('accepted_list_id')
    core.stub(:prompt_selection).with("Which Trello list would you like to put 'rejected' stories into?", trello.list_choices).and_return('rejected_list_id')
    core.stub(:prompt_selection).with("Which Trello list would you like to put 'backlog' bugs into?", trello.list_choices).and_return('bug_list_id')
    core.stub(:prompt_selection).with("Which Trello list would you like to put 'backlog' chores into?", trello.list_choices).and_return('chore_list_id')
    core.stub(:prompt_selection).with("Which Trello list would you like to put 'backlog' features into?", trello.list_choices).and_return('feature_list_id')
    core.stub(:prompt_selection).with("Which Trello list would you like to put 'backlog' releases into?", trello.list_choices).and_return('release_list_id')
    core.stub(:prompt_selection).with('What color would you like to label bugs with?', trello.label_choices).and_return('bug_label')
    core.stub(:prompt_selection).with('What color would you like to label features with?', trello.label_choices).and_return('feature_label')
    core.stub(:prompt_selection).with('What color would you like to label chores with?', trello.label_choices).and_return('chore_label')
    core.stub(:prompt_selection).with('What color would you like to label releases with?', trello.label_choices).and_return('release_label')
  end

  context '#import!' do
    it 'prompts the user for details' do
      core.import!
      core.options.should == mock_options
    end

    describe 'story handling' do
      let(:card)  { mock_trello_card }
      let(:story) { mock_pivotal_story }

      before(:each) do
        pivotal.should_receive(:stories).and_return([story])
        trello.stub(:add_label => true, :create_card => card)
      end

      it 'handles accepted stories' do
        story.stub(:current_state => 'accepted')
        trello.should_receive(:create_card).with(core.options.accepted_list_id, story).and_return(card)
        core.import!
      end

      it 'handles rejected stories' do
        story.stub(:current_state => 'rejected')
        trello.should_receive(:create_card).with(core.options.rejected_list_id, story).and_return(card)
        core.import!
      end

      it 'handles finished stories' do
        story.stub(:current_state => 'finished')
        trello.should_receive(:create_card).with(core.options.finished_list_id, story).and_return(card)
        core.import!
      end

      it 'handles delivered stories' do
        story.stub(:current_state => 'delivered')
        trello.should_receive(:create_card).with(core.options.delivered_list_id, story).and_return(card)
        core.import!
      end

      it 'handles unstarted features' do
        story.stub(:current_state => 'unstarted', :story_type => 'feature')
        trello.should_receive(:create_card).with(core.options.feature_list_id, story).and_return(card)
        core.import!
      end

      it 'handles unstarted chores' do
        story.stub(:current_state => 'unstarted', :story_type => 'chore')
        trello.should_receive(:create_card).with(core.options.chore_list_id, story).and_return(card)
        core.import!
      end

      it 'handles unstarted bugs' do
        story.stub(:current_state => 'unstarted', :story_type => 'bug')
        trello.should_receive(:create_card).with(core.options.bug_list_id, story).and_return(card)
        core.import!
      end

      it 'handles unstarted releases' do
        story.stub(:current_state => 'unstarted', :story_type => 'release')
        trello.should_receive(:create_card).with(core.options.release_list_id, story).and_return(card)
        core.import!
      end

      it 'labels stories' do
        story.stub(:story_type => 'bug')
        trello.should_receive(:add_label).with(card, 'bug', core.options.bug_label)
        core.import!
      end

      it 'ignores nil labels' do
        core.options.stub(:bug_label => nil)
        story.stub(:story_type => 'bug')
        trello.should_not_receive(:add_label)
        core.import!
      end
    end
  end
end

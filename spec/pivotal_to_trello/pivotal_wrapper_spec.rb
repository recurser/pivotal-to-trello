require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

describe 'PivotalWrapper' do
  let(:wrapper) { PivotalToTrello::PivotalWrapper.new('token') }

  context '#initialize' do
    it 'sets the pivotal token' do
      ::PivotalTracker::Client.should_receive(:token=).with('token')
      PivotalToTrello::PivotalWrapper.new('token')
    end
  end

  context '#project_choices' do
    it 'returns a hash of pivotal projects' do
      project = OpenStruct.new(:id => 'id', :name => 'My Project')
      ::PivotalTracker::Project.should_receive(:all).and_return([project])
      wrapper.project_choices.should == { 'id' => 'My Project'}
    end
  end

  context '#stories' do
    it 'returns an array of pivotal stories' do
      story   = mock_pivotal_story
      project = double(PivotalTracker::Project)
      ::PivotalTracker::Project.should_receive(:find).with('project_id').and_return(project)
      project.stub_chain(:stories, :all).and_return([story])
      wrapper.stories('project_id').should == [story]
    end
  end
end
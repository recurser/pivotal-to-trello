require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

describe 'PivotalWrapper' do
  let(:wrapper) { PivotalToTrello::PivotalWrapper.new('token') }

  context '#initialize' do
    it 'sets the pivotal token' do
      expect(::PivotalTracker::Client).to receive(:token=).with('token')
      PivotalToTrello::PivotalWrapper.new('token')
    end
  end

  context '#project_choices' do
    it 'returns a hash of pivotal projects' do
      project = OpenStruct.new(:id => 'id', :name => 'My Project')
      expect(::PivotalTracker::Project).to receive(:all).and_return([project])
      expect(wrapper.project_choices).to eq({ 'id' => 'My Project'})
    end
  end

  context '#stories' do
    it 'returns an array of pivotal stories' do
      story   = mock_pivotal_story
      project = double(PivotalTracker::Project)
      expect(::PivotalTracker::Project).to receive(:find).with('project_id').and_return(project)
      allow(project).to receive_message_chain(:stories, :all).and_return([story])
      expect(wrapper.stories('project_id')).to eq([story])
    end
  end
end
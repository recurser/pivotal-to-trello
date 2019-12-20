require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

describe 'PivotalWrapper' do
  # API Token is for a user with just one public sample project.
  let(:token)   { 'ab4c5895f57995bb7547986eacf91160' }
  let(:wrapper) { PivotalToTrello::PivotalWrapper.new(token) }

  context '#initialize' do
    it 'sets the pivotal token' do
      expect(TrackerApi::Client).to receive(:new).with(token: token)
      PivotalToTrello::PivotalWrapper.new(token)
    end
  end

  context '#project_choices' do
    it 'returns a hash of pivotal projects' do
      expect(wrapper.project_choices).to eq({1027488=>"My Sample Project", 1027492=>"My Sample Project"})
    end
  end

  context '#stories' do
    it 'returns a sorted array of pivotal stories' do
      expect(wrapper.get_client.project(1027488).id).to eq 1027488
      expect(wrapper.get_client.project(1027488).stories.count).to eq (85)
      expect(wrapper.get_client.project(1027488).stories.first.id).to eq(66727974)
      expect(wrapper.get_client.project(1027488).stories.last.id).to eq(66728090)
    end
  end
end

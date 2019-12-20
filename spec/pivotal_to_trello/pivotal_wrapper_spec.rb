# frozen_string_literal: true

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
      expect(wrapper.project_choices).to eq(1_027_488 => 'My Sample Project', 1_027_492 => 'My Sample Project')
    end
  end

  context '#stories' do
    it 'returns a sorted array of pivotal stories' do
      expect(wrapper.project(1_027_488).id).to eq 1_027_488
      expect(wrapper.project(1_027_488).stories.count).to eq 85
      expect(wrapper.project(1_027_488).stories.first.id).to eq(66_727_974)
      expect(wrapper.project(1_027_488).stories.last.id).to eq(66_728_090)
    end
  end
end

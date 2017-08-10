$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'pivotal-to-trello'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
end

def mock_pivotal_wrapper
  pivotal = double(PivotalToTrello::PivotalWrapper)
  allow(pivotal).to receive_messages(project_choices: {})
  allow(pivotal).to receive_messages(stories: [])
  pivotal
end

def mock_trello_wrapper
  trello = double(PivotalToTrello::TrelloWrapper)
  allow(trello).to receive_messages(board_choices: {})
  allow(trello).to receive_messages(list_choices: {})
  allow(trello).to receive_messages(label_choices: {})
  trello
end

def mock_pivotal_story(options = {})
  options = {
    name:          'My Story',
    description:   'My Description',
    current_state: 'unstarted',
    story_type:    'feature',
  }.merge(options)
  story = double(PivotalTracker::Story)
  allow(story).to receive_message_chain(:notes, :all).and_return([])
  allow(story).to receive_message_chain(:tasks, :all).and_return([])
  options.each { |k, v| allow(story).to receive_messages(k => v) }
  story
end

def mock_trello_card(options = {})
  options = {
    name:     'My Card',
    desc:     'My Description',
    board_id: 1_234_321,
  }.merge(options)
  card = double(Trello::Card)
  options.each { |k, v| allow(card).to receive_messages(k => v) }
  card
end

def mock_options
  OpenStruct.new( pivotal_project_id: 'pivotal_project_id',
                  trello_board_id:    'trello_board_id',
                  icebox_list_id:     'icebox_list_id',
                  current_list_id:    'current_list_id',
                  finished_list_id:   'finished_list_id',
                  delivered_list_id:  'delivered_list_id',
                  accepted_list_id:   'accepted_list_id',
                  rejected_list_id:   'rejected_list_id',
                  bug_list_id:        'bug_list_id',
                  chore_list_id:      'chore_list_id',
                  feature_list_id:    'feature_list_id',
                  release_list_id:    'release_list_id',
                  bug_label:          'bug_label',
                  feature_label:      'feature_label',
                  chore_label:        'chore_label',
                  release_label:      'release_label')
end

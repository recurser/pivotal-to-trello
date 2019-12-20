# frozen_string_literal: true

unless defined? P2T_ROOT
  $LOAD_PATH << __dir__
  P2T_ROOT   = File.expand_path(File.dirname(__FILE__) + '/../')
  P2T_LIB    = File.join(P2T_ROOT, 'lib', 'pivotal_to_trello')
end

module PivotalToTrello
  def self.version
    File.exist?(File.join(P2T_ROOT, 'VERSION')) ? File.read(File.join(P2T_ROOT, 'VERSION')) : 'Unknown'
  end

  require 'pivotal_to_trello/core'
  require 'pivotal_to_trello/pivotal_wrapper'
  require 'pivotal_to_trello/runner'
  require 'pivotal_to_trello/trello_wrapper'
end

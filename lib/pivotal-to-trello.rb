unless defined? P2T_ROOT
  $LOAD_PATH       << File.expand_path(File.dirname(__FILE__))
  P2T_ROOT   = File.expand_path(File.dirname(__FILE__) + '/../')
  P2T_LIB    = File.join(P2T_ROOT, 'lib', 'pivotal_to_trello')
end

# The top-level namespace, a home for all Ruby-Processing classes.
module PivotalToTrello
  def self.version
    File.exist?(File.join(P2T_ROOT, 'VERSION')) ? File.read(File.join(P2T_ROOT, 'VERSION')) : 'Unknown'
  end

  require 'pivotal_to_trello/core'
  require 'pivotal_to_trello/runner'
end
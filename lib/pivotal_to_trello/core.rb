require 'rubygems'

module PivotalToTrello
  # The core entry point of the gem, which handles the import process.
  class Core

    # Constructor
    def initialize(options = OpenStruct.new)
      @options = options
    end

    # Imports a Pivotal project into Trello.
    def import!
      p 'Importing!'
    end

  end
end
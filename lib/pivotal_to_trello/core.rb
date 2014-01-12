require 'rubygems'

module PivotalToTrello
  # The core entry point of the gem, which handles the import process.
  class Core

    # Constructor
    def initialize(options = OpenStruct.new)
      @options = options
    end

    # Generates a film clip based on the given input audio file, and saves it
    # to the given output path.
    def import!
      p 'Importing!'
    end

  end
end
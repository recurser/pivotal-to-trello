require 'optparse'
require 'ostruct'

module PivotalToTrello
  # Utility class to handle the different commands that the 'pivotal-to-trello'
  # command offers.
  class Runner
    # Start running a pivotal-to-trello command from the passed-in arguments.
    def self.execute
      runner  = new
      options = runner.parse_options(ARGV)
      runner.execute!(options)
    end

    # Dispatch central.
    def execute!(options)
      case options.action
      when :import then import(options)
      end
    end

    # Parses the options, and displays help messages if the options given are
    # incorrect.
    def parse_options(args)
      options = OpenStruct.new

      commands = {
        'import' => OptionParser.new do |opts|
          opts.banner = 'Usage: pivotal-to-trello import [options]'
          opts.separator ''
          opts.separator 'All arguments except for -v and -h are required.'
          opts.separator ''
          opts.separator 'Options:'

          opts.on('-k', '--trello-key KEY', 'Trello application key') do |trello_key|
            options.trello_key = trello_key
          end
          opts.on('-t', '--trello-token TOKEN', 'Trello member token') do |trello_token|
            options.trello_token = trello_token
          end
          opts.on('-p', '--pivotal-token TOKEN', 'Pivotal Tracker API token') do |pivotal_token|
            options.pivotal_token = pivotal_token
          end
          opts.on('-d', '--pivotal-project-id ID', 'Pivotal Tracker project ID to export from') do |pivotal_project_id|
            options.pivotal_project_id = pivotal_project_id
          end
          opts.on('-b', '--trello-board BOARD_NAME', 'Name of the Trello board to import to') do |trello_board|
            options.trello_board = trello_board
          end
          opts.on('-i', '--icebox-list LIST_NAME', 'Name of the Trello list to import Pivotal Icebox stories to') do |icebox_list|
            options.icebox_list = icebox_list
          end
          opts.on('-l', '--backlog-list LIST_NAME', 'Name of the Trello list to import Pivotal Backlog stories to') do |backlog_list|
            options.backlog_list = backlog_list
          end
          opts.on('-e', '--bug-list LIST_NAME', 'Name of the Trello list to import Pivotal Bugs to') do |bug_list|
            options.bug_list = bug_list
          end
          opts.on('-c', '--current-list LIST_NAME', 'Name of the Trello list to import Pivotal Current stories to') do |current_list|
            options.current_list = current_list
          end

          # Miscellaneous.
          opts.on_tail('-v', '--version', 'Show version information') { show_version }
          opts.on_tail('-h', '--help', 'Show this message') do
            STDOUT.write opts
            exit
          end

          opts.on do
            if options.trello_key && \
               options.trello_token && \
               options.pivotal_token && \
               options.pivotal_project_id && \
               options.trello_board && \
               options.icebox_list && \
               options.backlog_list && \
               options.bug_list && \
               options.current_list
              options.action = :import
            else
              # Output a help message unless the required options have been specified.
              options.action = :error
              STDOUT.write commands['import']
            end
          end
        end,
      }

      global = OptionParser.new do |opts|
        opts.banner = "Usage: pivotal-to-trello [#{commands.keys.join(', ')}] [options]"

        opts.separator ''
        opts.separator 'pivotal-to-trello is a library for importing stories from Pivotal Tracker into Trello.'
        opts.separator ''
        opts.separator "Use pivotal-to-trello [#{commands.keys.join(', ')}] -h to find out more about a specific command"
        opts.separator ''
        opts.separator 'Other options:'

        opts.on_tail('-v', '--version', 'Show version information') do
          show_version
          exit
        end

        opts.on_tail('-h', '--help', 'Show this message') do
          STDOUT.write opts
          exit
        end
      end

      global.order!
      command = args.shift
      commands[command].order! if commands[command]

      # Output a help message unless a command has been specified.
      STDOUT.write global unless options.action

      options
    end

    # Generates a film clip for the given input file, and saves it to the given
    # output path.
    def import(options)
      PivotalToTrello::Core.new(options).import!
    end

    # Display the current version of Ruby-Processing.
    def show_version
      STDOUT.write "pivotal-to-trello version #{PivotalToTrello.version}"
    end
  end # class Runner
end # module PivotalToTrello

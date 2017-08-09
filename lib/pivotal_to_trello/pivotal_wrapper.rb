require 'pivotal-tracker'

module PivotalToTrello
  # Interface to the Pivotal Tracker API.
  class PivotalWrapper

    # Constructor
    def initialize(token)
      ::PivotalTracker::Client.token = token
      ::PivotalTracker::Client.use_ssl = true
    end

    # Returns a hash of available projects keyed on project ID.
    def project_choices
      ::PivotalTracker::Project.all.inject({}) do |hash, project|
        hash[project.id] = project.name
        hash
      end
    end

    # Returns all stories for the given project.
    def stories(project_id)
      project(project_id).stories.all
    end

    private

      # Returns the Pivotal project that we're exporting.
      def project(project_id)
        @projects             ||= {}
        @projects[project_id] ||= ::PivotalTracker::Project.find(project_id)
      end

  end
end

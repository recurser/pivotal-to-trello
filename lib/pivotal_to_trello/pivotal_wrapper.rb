require 'tracker_api'

module PivotalToTrello
  # Interface to the Pivotal Tracker API.
  class PivotalWrapper
    # Constructor
    def initialize(token)
      @client = TrackerApi::Client.new(token: token)
    end

    # Returns a hash of available projects keyed on project ID.
    def project_choices
      @client.projects.each_with_object({}) do |project, hash|
        hash[project.id] = project.name
      end
    end

    # Returns all stories for the given project.
    def stories(project_id)
      @client.project(project_id).stories.sort_by(&:created_at)
    end

    #i have no idea why the project method is private so i had to add this to get passing tests
    def get_client
      @client
    end

    private

    # Returns the Pivotal project that we're exporting.
    def project(project_id)
      @projects             ||= {}
      @projects[project_id] ||= @client.project(project_id)
    end
  end
end

# frozen_string_literal: true

require 'trello'

module PivotalToTrello
  # Interface to the Trello API.
  class TrelloWrapper
    # Constructor
    def initialize(key, token)
      Trello.configure do |config|
        config.developer_public_key = key
        config.member_token         = token
      end
    end

    # Creates a card in the given list if one with the same name doesn't already exist.
    def create_card(list_id, pivotal_story)
      card   = get_card(list_id, pivotal_story.name, pivotal_story.description)
      card ||= begin
        puts "Creating a card for #{pivotal_story.story_type} '#{pivotal_story.name}'."
        card = Trello::Card.create(
          name:    pivotal_story.name,
          desc:    pivotal_story.description,
          list_id: list_id,
        )

        create_comments(card, pivotal_story)
        create_tasks(card, pivotal_story)
        card
      end

      key                  = card_hash(card.name, card.desc)
      @cards             ||= {}
      @cards[list_id]    ||= {}
      @cards[list_id][key] = card
    end

    # Returns a hash of available boards, keyed on board ID.
    def board_choices
      Trello::Board.all.each_with_object({}) do |board, hash|
        hash[board.id] = board.name
      end
    end

    # Returns a hash of available lists for the given board, keyed on board ID.
    def list_choices(board_id)
      # Cache the list to improve performance.
      @lists           ||= {}
      @lists[board_id] ||= begin
        choices = Trello::Board.find(board_id).lists.each_with_object({}) do |list, hash|
          hash[list.id] = list.name
        end
        choices = Hash[choices.sort_by { |_, v| v }]
        choices[false] = "[don't import these stories]"
        choices
      end

      @lists[board_id]
    end

    # Returns a list of all cards in the given list, keyed on name.
    def cards_for_list(list_id)
      @cards          ||= {}
      @cards[list_id] ||= Trello::List.find(list_id).cards.each_with_object({}) do |card, hash|
        hash[card_hash(card.name, card.desc)] = card
      end

      @cards[list_id]
    end

    # Adds the given label to the card.
    def add_label(card, label_name, label_color)
      @labels                ||= {}
      @labels[card.board_id] ||= Trello::Board.find(card.board_id).labels
      label                    = @labels[card.board_id].find { |l| l.name == label_name && l.color == label_color }
      label                  ||= Trello::Label.create(name: label_name, board_id: card.board_id, color: label_color)

      card.add_label(label) unless card.labels.detect { |l| l.id == label.id }
    end

    # Returns a list of colors that can be used to label cards.
    def label_choices
      {
        'blue'   => 'Blue',
        'green'  => 'Green',
        'orange' => 'Orange',
        'purple' => 'Purple',
        'red'    => 'Red',
        'yellow' => 'Yellow',
        false    => '[none]',
      }
    end

    private

    # Copies notes from the pivotal story to the card.
    def create_comments(card, pivotal_story)
      pivotal_story.comments.each do |comment|
        card.add_comment(comment.text.to_s.strip.to_s) unless comment.text.to_s.strip.empty?
      end
    end

    # Copies notes from the pivotal story to the card.
    def create_tasks(card, pivotal_story)
      tasks = pivotal_story.tasks
      return if tasks.empty?

      checklist = Trello::Checklist.create(name: 'Tasks', card_id: card.id)
      card.add_checklist(checklist)

      tasks.each do |task|
        puts " - Creating task '#{task.description}'"
        checklist.add_item(task.description, task.complete)
      end
    end

    # Returns a unique identifier for this list/name/description combination.
    def card_hash(name, description)
      Digest::SHA1.hexdigest("#{name}_#{description}")
    end

    # Returns a card with the given name and description if it exists in the given list, nil otherwise.
    def get_card(list_id, name, description)
      key = card_hash(name, description)
      cards_for_list(list_id)[key] unless cards_for_list(list_id)[key].nil?
    end
  end
end

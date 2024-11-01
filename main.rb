# Exercise 5

class LaunchDiscussionWorkflow

  def initialize(discussion, host, participants_email_string)
    @discussion = discussion
    @host = host
    @participants = Participants.new(participants_email_string)
  end

  # BROKE APART THE run() METHOD INTO DIFFERENT METHODS
  # I LIKE CAMEL CASE BUT RUBY PREFERS SNAKE CASE :( BIG BOO 
  def state_valid?
    valid?
  end

  def save_state
    discussion.save!
  end

  def run
    return unless state_valid?
    run_callbacks(:create) do
      ActiveRecord::Base.transaction do
        save_state
        create_discussion_roles!
        @successful = true
      end
    end
  end
end


# CREATE A CLASS TO HANDLE THE PARTICIPANTS
class Participants
  def initialize(email_string)
    @participants_email_string = email_string
  end

  # HAVE THIS METHOD IN OUR NEW CLASS SO THAT THE PREVIOUS CLASS HAS LESS RESPONSIBILITY
  def generate_users
    return [] if @participants_email_string.blank?
    @participants_email_string.split.uniq.map do |email_address|
      User.create(email: email_address.downcase, password: Devise.friendly_token)
    end
  end
end

discussion = Discussion.new(title: "fake", ...)
host = User.find(42)
participants = "fake1@example.com\nfake2@example.com\nfake3@example.com"

workflow = LaunchDiscussionWorkflow.new(discussion, host, participants)
workflow.run

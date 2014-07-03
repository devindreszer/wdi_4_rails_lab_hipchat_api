class Poke < ActiveRecord::Base
  ROOM = "WDI Boston PokeChat"
  validates :author_line, :target_username, :content, presence: true

  def targets
    client = HipChat::Client.new(ENV['HIPCHAT_TOKEN'], :api_version => 'v2')
    participant_names = []
    client[ROOM].get_room["participants"].each do |participant|
      participant_names << participant["name"]
    end
    participant_names
  end
end

class Poke < ActiveRecord::Base
  CLIENT = HipChat::Client.new(ENV['HIPCHAT_TOKEN'], :api_version => 'v2')
  ROOM = "WDI Boston PokeChat"
  validates :author_line, :target_username, :content, presence: true

  def targets
    participant_names = []
    CLIENT[ROOM].get_room["participants"].each do |participant|
      participant_names << participant["mention_name"]
    end
    participant_names
  end
end

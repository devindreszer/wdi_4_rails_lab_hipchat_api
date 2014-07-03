class PokesController < ApplicationController
  def show
    @poke = Poke.find(params[:id])
  end

  def new
    @poke = Poke.new
  end

  def create
    @poke = Poke.new(poke_params)

    if @poke.save
      @poke.is_private ? private_poke(@poke) : public_poke(@poke)
      redirect_to @poke, success: 'Target has been poked!'
    else
      flash.now.alert = "Slight problem: #{@poke.errors.full_messages.join(', ')}"
      render :new
    end
  end

  private

  def poke_params
    params.require(:poke).permit(:author_line, :target_username, :content, :is_private)
  end

  def public_poke(poke)
    Poke::CLIENT[Poke::ROOM].send('', "@#{poke.target_username} #{poke.content} by #{poke.author_line}: #{poke_url(poke)}}", :message_format => 'text')
  end

  def private_poke(poke)
    participants = Poke::CLIENT[Poke::ROOM].get_room["participants"]
    target = nil
    participants.each do |participant|
      target = participant if participant["mention_name"] == "#{poke.target_username}"
    end
    id = target["id"]
    Poke::CLIENT.user(id).send("@#{poke.target_username} #{poke.content} by #{poke.author_line}: #{poke_url(poke)}")
  end
end

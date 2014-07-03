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
      public_poke(@poke)
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
    client = HipChat::Client.new(ENV['HIPCHAT_TOKEN'], :api_version => 'v2')
    client[Poke::ROOM].send('', "@#{poke.target_username} #{poke.content} by #{poke.author_line}: #{request.original_url}", :message_format => 'text')
  end
end

require_relative 'base.rb'

module Site
  module Routes
    class PlayerRoute < Base
      get '/players/:id/games/?' do
        @player = Player.get(params[:id])
        render_page :game_list
      end

      get '/players/:id/game/:game_id/?' do
        @game_player = GamePlayer.get(params[:game_id], params[:id])
        @player = @game_player.player
        @game = @game_player.game
        @can_vote = @game.voters.first(ip: request.ip).nil?
        render_page :game
      end

      post '/players/:id/game/:game_id/?' do
        game = Game.get(params[:game_id])
        unless game.winners.map(&:id).include? params[:winner_confirm].to_i
          Voter.create(ip: request.ip, game: game)
          redirect to "#{request.referrer}?error=incorrect_winner"
        end
        if game.voters.first(ip: request.ip).nil?
          Voter.create(ip: request.ip, game: game)
          player = GamePlayer.get(params[:id], params[:game_id]).player
          if params[:verdict] == "Guilty"
            player.update(guilty_count: player.guilty_count + 1)
          end
          if params[:verdict] == "Innocent"
            player.update(innocent_count: player.innocent_count + 1)
          end
        end
        redirect to '/list/recent'
      end
    end
  end
end

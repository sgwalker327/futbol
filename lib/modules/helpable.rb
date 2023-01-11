module Helpable

  def visitor_scores_hash
    games_grouped_by_away_team = teams_by_id
    average_away_goals_per_team = {}

    games_grouped_by_away_team.each do |team, games|
      average_away_goals_per_team[team] = 0
        games.each do |game|
        average_away_goals_per_team[team] += game[:goals].to_i if game[:hoa] == "away"
      end
      average_away_goals_per_team[team] = (average_away_goals_per_team[team].to_f / games.size).round(2)
    end
    average_away_goals_per_team
  end

  def home_scores_hash
		games_grouped_by_home_team = teams_by_id
		average_home_goals_per_team = {}

		games_grouped_by_home_team.each do |team, games|
			average_home_goals_per_team[team] = 0
				games.each do |game|
				average_home_goals_per_team[team] += game[:goals].to_i if game[:hoa] == "home"
			end
			average_home_goals_per_team[team] = (average_home_goals_per_team[team].to_f / games.size).round(2)
		end
		average_home_goals_per_team
	end

  def average_goals_by_team_hash 
    games_grouped_by_team = teams_by_id
    average_goals_per_team = {}
    games_grouped_by_team.each do |team, games| 
      total_goals = games.sum do |game| 
        game[:goals].to_i 
      end
      average_goals_per_team[team] = (total_goals / games.count.to_f).round(2)
    end
    average_goals_per_team
  end 

  def teams_with_tackles(games_array) 
  hash = Hash.new{|k,v| k[v] = []}
  games_array.each do |game_id|
  next if games_by_game_id[game_id].nil?
    games_by_game_id[game_id].each do |game|
      hash[game[:team_id]] << game[:tackles].to_i
    end
  end
    hash
  end

  def team_shots_by_season(season_id) 
    hash = Hash.new{|k,v| k[v] = []}
    game_ids_by_season(season_id).each do |game_id| 
        games_by_game_id.each do |id, game| 
          if id == game_id 
            game.each do |row|
          hash[row[:team_id]] << row[:shots].to_i
          end
        end
      end
    end
    hash
  end

  def team_goals_by_season(season_id)
    hash = Hash.new{|k,v| k[v] = []}
    game_ids_by_season(season_id).each do |game_id| 
        games_by_game_id.each do |id, game| 
          if id == game_id 
            game.each do |row|
          hash[row[:team_id]] << row[:goals].to_i
          end
        end
      end
    end
    hash
  end

  def team_info_hash(team_id)
  team_info_hash = Hash.new
  @team_path.map do |row|
      if team_id == row[:team_id]
        team_info_hash["team_id"] = row[:team_id]
        team_info_hash["franchise_id"] = row[:franchiseid]
        team_info_hash["team_name"] = row[:teamname]
        team_info_hash["abbreviation"] = row[:abbreviation]
        team_info_hash["link"] = row[:link]
      end
    end
    team_info_hash  
  end

  def wins_by_coach(game_id_array) 
    hash = Hash.new{|k, v| k[v] = []}
    game_id_array.each do |game_id|
      next if games_by_game_id[game_id].nil?
      games_by_game_id[game_id].each do |game|
        hash[game[:head_coach]] << game[:result]
      end
    end
    hash 
  end
  
def pair_season_with_results_by_team(team_id) 
    hash = Hash.new{|k,v| k[v] = []}
    pair_teams_with_results(team_id).each do |team, results|
      results.each do |result|
      data = games_by_id_game_path[result[1]][0]
        hash[data[:season]] << result[0]
      end
    end
    hash
  end

  def pair_teams_with_results(team_id)
    hash = Hash.new{|k,v| k[v] = []}
    teams_by_id[team_id].each do |game|
      hash[team_id] << game[:result]
      hash[team_id] << game[:game_id]
    end
    hash.each do |team_id, value|
      hash[team_id] = value.each_slice(2).to_a
    end
    hash
   end

    def win_average_helper(team_id)
    opponents_games = games_by_team_id[team_id].flat_map do |game|
      games_by_game_id[game[:game_id]].select { |element| element[:team_id]!= team_id }
    end
    results_hash = opponents_games.group_by {|game| game[:team_id] }
      results_hash.map do |team, games|
        game_result =  games.find_all {|game| game[:result] == 'WIN'}
        
        [((game_result.count.to_f / games.count) * 100).round(2), team]
      end
  end

  def home_wins_array 
    @game_path.find_all do |row|
     row[:home_goals].to_i > row[:away_goals].to_i
    end
  end

  def visitor_wins_array 
    @visitor_wins_array ||= @game_path.find_all do |row|
        row[:away_goals].to_i > row[:home_goals].to_i
    end
  end

	def count_of_games_by_season 
		season_id = games_by_season
		season_id.each do |season, game|
			season_id[season] = game.count
		end
	end

  	def ties_array 
		@ties_array ||= @game_path.find_all do |row|
			row[:away_goals].to_i == row[:home_goals].to_i
		end
	end
end
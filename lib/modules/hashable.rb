module Hashable

  def visitor_scores_hash
    games_grouped_by_away_team = @game_teams_path.group_by {|row| row[:team_id]}
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
		games_grouped_by_home_team = @game_teams_path.group_by {|row| row[:team_id]}
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
    games_grouped_by_team = @game_teams_path.group_by {|row| row[:team_id]}
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
end
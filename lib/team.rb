require 'csv'

class Team
  attr_reader :team_path,
              :game_path,
              :game_teams_path,
              :team_id,
              :team_name

  def initialize(file_path, file_path2, file_path3)
    @team_path = file_path
    @game_teams_path = file_path2
    @game_path = file_path3
    @team_id = file_path[:team_id]
    @team_name = file_path[:teamname]
  end

  def count_of_teams
    @team_path.count
  end

  
  def best_offense
    best = average_goals_by_team_hash.max_by {|k,v| v}
    
    @team_path.map do |team| 
      if team[:team_id] == best[0]
        team[:teamname]
      end
    end.compact.pop
  end
  
  def worst_offense 
    worst = average_goals_by_team_hash.min_by {|k,v| v}
    
    @team_path.map do |team| 
      if team[:team_id] == worst[0]
        team[:teamname]
      end
    end.compact.pop
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

  def highest_scoring_visitor
		visitor_highest = visitor_scores_hash.max_by {|k,v| v }
		@team_path.map do |team| 
      if team[:team_id] == visitor_highest[0]
        team[:teamname]
      end
    end.compact.pop
	end

  def lowest_scoring_visitor
		visitor_lowest = visitor_scores_hash.min_by {|k,v| v}
		@team_path.map do |team| 
      if team[:team_id] == visitor_lowest[0]
        team[:teamname]
      end
    end.compact.pop
	end

  def highest_scoring_home_team
		home_highest = home_scores_hash.max_by { |k, v| v }
		@team_path.map do |team|
			if team[:team_id] == home_highest[0]
				team[:teamname]
			end
		end.compact.pop
	end

  def lowest_scoring_home_team
		home_lowest = home_scores_hash.min_by {|k,v| v}
		@team_path.map do |team| 
      if team[:team_id] == home_lowest[0]
        team[:teamname]
      end
    end.compact.pop
	end

  def most_tackles(season_id)
    team_tackles = teams_with_tackles(game_ids_by_season(season_id))
    team_tackles.each do |team, tackles| 
      team_tackles[team] = tackles.sum
    end

    team_with_most_tackles = @team_path.find do |row| 
      if row[:team_id] == team_tackles.invert[team_tackles.invert.keys.max] 
        row[:teamname]
      end
    end
    team_with_most_tackles[:teamname]
  end

  def fewest_tackles(season_id)
    team_tackles = teams_with_tackles(game_ids_by_season(season_id))
    team_tackles.each do |team, tackles| 
      team_tackles[team] = tackles.sum
    end

    team_with_fewest_tackles = @team_path.find do |row| 
      if row[:team_id] == team_tackles.invert[team_tackles.invert.keys.min] 
        row[:teamname]
      end
    end
    team_with_fewest_tackles[:teamname]
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

  def games_by_season  #ask about testing for this method 138
    @games_by_season ||= @game_path.group_by do |row|
      row[:season] 
    end
  end

  def games_by_game_id #and this one 132
    @games_by_game_id ||= @game_teams_path.group_by do |row| 
      row[:game_id]
    end
  end

  def game_ids_by_season(season_id) 
    games_by_season[season_id].map do |games|
      games[:game_id]
    end
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

  def get_ratios_by_season_id(season_id)
    merged_hash = team_shots_by_season(season_id).merge(team_goals_by_season(season_id)) {|key, old_val, new_val| new_val.sum / old_val.sum.to_f}
  end

  def most_accurate_team(season_id) 
    most_good = get_ratios_by_season_id(season_id).max_by{|k,v| v}
    winner = @team_path.find do |row| 
      row[:team_id] == most_good[0]
    end
    winner = winner[:teamname]
  end

   def least_accurate_team(season_id) 
    least_good = get_ratios_by_season_id(season_id).min_by{|k,v| v}
    loser = @team_path.find do |row| 
      row[:team_id] == least_good[0]
    end
    loser = loser[:teamname]
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

  def team_info(team_id)
    hash = Hash.new
    @team_path.map do |row|
      if team_id == row[:team_id]
        hash["team_id"] = row[:team_id]
        hash["franchise_id"] = row[:franchiseid]
        hash["team_name"] = row[:teamname]
        hash["abbreviation"] = row[:abbreviation]
        hash["link"] = row[:link]
      end
    end
    hash
  end

 def team_name_by_team_id(team_id)
    @team_path.find do |team|
      team[:team_id] == team_id
    end[:teamname]
  end


  def games_by_team_id 
    @games_by_team_id ||= @game_teams_path.group_by do |row|
      row[:team_id]
    end
  end

  def win_average_helper(team_id)
    opponents_games = games_by_team_id[team_id].flat_map do |game|
      games_by_game_id[game[:game_id]].select { |element| element[:team_id]!= team_id }
    end
    results_hash = opponents_games.group_by {|game| game[:team_id]}
      results_hash.map do |team, games|
        game_result =  games.find_all {|game| game[:result] == 'WIN'}
        
        [((game_result.count.to_f / games.count) * 100).round(2), team]
      end
  end

  def favorite_opponent(team_id)
   opponent_id = win_average_helper(team_id).min.last
   team_name_by_team_id(opponent_id)
  end

  def rival(team_id)
    rival_id = win_average_helper(team_id).max.last
    team_name_by_team_id(rival_id)
  end
end
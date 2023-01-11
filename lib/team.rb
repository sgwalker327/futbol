require 'csv'
require_relative 'modules/hashable'
require_relative 'modules/groupable'

class Team
  include Hashable
  include Groupable

  attr_reader :team_path,
              :game_path,
              :game_teams_path

  def initialize(file_path, file_path2, file_path3)
    @team_path = file_path
    @game_teams_path = file_path2
    @game_path = file_path3
  end

  def count_of_teams
    @team_path.count
  end

  def best_offense
    best = average_goals_by_team_hash.max_by {|k,v| v}
    @team_path.map do |team| 
      team[:teamname] if team[:team_id] == best[0]
    end.compact.pop
  end
  
  def worst_offense 
    worst = average_goals_by_team_hash.min_by {|k,v| v}
    @team_path.map do |team| 
      team[:teamname]if team[:team_id] == worst[0]
    end.compact.pop
  end
  
  def highest_scoring_visitor
		visitor_highest = visitor_scores_hash.max_by {|k,v| v }
		@team_path.map do |team| 
      team[:teamname] if team[:team_id] == visitor_highest[0]
    end.compact.pop
	end

  def lowest_scoring_visitor
		visitor_lowest = visitor_scores_hash.min_by {|k,v| v}
		@team_path.map do |team| 
     team[:teamname] if team[:team_id] == visitor_lowest[0]
    end.compact.pop
	end

  def highest_scoring_home_team
		home_highest = home_scores_hash.max_by { |k, v| v }
		@team_path.map do |team|
			team[:teamname] if team[:team_id] == home_highest[0]
		end.compact.pop
	end

  def lowest_scoring_home_team
		home_lowest = home_scores_hash.min_by {|k,v| v}
		@team_path.map do |team| 
      team[:teamname] if team[:team_id] == home_lowest[0]
    end.compact.pop
	end

  def most_tackles(season_id)
    team_tackles = teams_with_tackles(game_ids_by_season(season_id))
    team_tackles.each do |team, tackles| 
      team_tackles[team] = tackles.sum
    end
    team_with_most_tackles = @team_path.find do |row| 
      row[:teamname] if row[:team_id] == team_tackles.invert[team_tackles.invert.keys.max] 
    end
    team_with_most_tackles[:teamname]
  end

  def fewest_tackles(season_id)
    team_tackles = teams_with_tackles(game_ids_by_season(season_id))
    team_tackles.each do |team, tackles| 
      team_tackles[team] = tackles.sum
    end
    team_with_fewest_tackles = @team_path.find do |row| 
     row[:teamname] if row[:team_id] == team_tackles.invert[team_tackles.invert.keys.min] 
    end
    team_with_fewest_tackles[:teamname]
  end

  def most_accurate_team(season_id) 
    most_good = get_ratios_by_season_id(season_id).max_by{|k,v| v}
    winner = @team_path.find { |row| row[:team_id] == most_good[0] }
    winner = winner[:teamname]
  end

   def least_accurate_team(season_id) 
    least_good = get_ratios_by_season_id(season_id).min_by{|k,v| v}
    loser = @team_path.find { |row| row[:team_id] == least_good[0] }
    loser = loser[:teamname]
  end

  def team_info(team_id)
    team_info_hash(team_id)
  end

 def team_name_by_team_id(team_id)
    @team_path.find do |team|
      team[:team_id] == team_id
    end[:teamname]
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

  def favorite_opponent(team_id)
   opponent_id = win_average_helper(team_id).min.last
   team_name_by_team_id(opponent_id)
  end

  def rival(team_id)
    rival_id = win_average_helper(team_id).max.last
    team_name_by_team_id(rival_id)
  end
end
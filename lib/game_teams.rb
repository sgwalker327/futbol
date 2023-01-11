require 'spec_helper'
require_relative 'modules/groupable'
require_relative 'modules/helpable'

class GameTeams 
  include Groupable
  include Helpable
  attr_reader :game_teams_path, :game_path, :team_path
  
  def initialize(file_path, file_path2, file_path3)
    @game_teams_path = file_path
    @game_path = file_path2
    @team_path = file_path3
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

  def most_goals_scored(team_id) 
    all_scores_by_team[team_id.to_s].max
  end

  def fewest_goals_scored(team_id) 
    all_scores_by_team[team_id.to_s].min
  end

  def best_season(team_id) 
    best_season_hash = {}
    best = pair_season_with_results_by_team(team_id)
  
    best.each do |season, results|
      best_season_hash[season] = results.count("WIN") / results.count.to_f
    end
    best_season_for_team = best_season_hash.max_by {|k,v| v}
    best_season_for_team[0]
  end
 
  def worst_season(team_id) 
    worst_season_hash = {}
    worst = pair_season_with_results_by_team(team_id)
  
    worst.each do |season, results|
      worst_season_hash[season] = results.count("WIN") / results.count.to_f
    end
    worst_season_for_team = worst_season_hash.min_by {|k,v| v}
    worst_season_for_team[0]
  end

  def average_win_percentage(team_id) 
    average_hash = Hash.new{|k,v| k[v] = []}
    team_games = teams_by_id[team_id]
    team_games.each do |game|
      average_hash[team_id] << game[:result] if game[:result] == 'WIN'
    end
    average_win_percent = (average_hash.values[0].count('WIN') / team_games.count.to_f).round(2)
  end

  def winningest_coach(season_id) 
    coach_results = wins_by_coach(game_ids_by_season(season_id)) 
     coach_results.each do |coach, results| 
      coach_results[coach] = (results.count("WIN") / (results.count.to_f / 2))
     end
     coach_results.invert[coach_results.invert.keys.max]
  end

  def worst_coach(season_id) 
    coach_results = wins_by_coach(game_ids_by_season(season_id)) 
     coach_results.each do |coach, results| 
      coach_results[coach] = (results.count("WIN") / (results.count.to_f / 2))
     end
     coach_results.invert[coach_results.invert.keys.min]
  end
end
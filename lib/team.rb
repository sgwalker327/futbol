require 'spec_helper'
require_relative 'modules/helpable'
require_relative 'modules/groupable'

class Team
  include Helpable
  include Groupable

  attr_reader :team_path, :game_path, :game_teams_path

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

  def favorite_opponent(team_id)
   opponent_id = win_average_helper(team_id).min.last
   team_name_by_team_id(opponent_id)
  end

  def rival(team_id)
    rival_id = win_average_helper(team_id).max.last
    team_name_by_team_id(rival_id)
  end
end
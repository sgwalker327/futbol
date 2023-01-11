require 'csv'
require_relative 'game_teams'
require_relative 'game'
require_relative 'team'

class StatTracker
  attr_reader :game_path,
              :team_path,
              :game_teams_path
              :game
       
  def initialize(locations)
    @game_path = CSV.read(locations[:games], headers: true, skip_blanks: true, header_converters: :symbol)
    @team_path = CSV.read(locations[:teams], headers: true, skip_blanks: true, header_converters: :symbol)
    @game_teams_path = CSV.read(locations[:game_teams], headers: true, skip_blanks: true, header_converters: :symbol)
    @game = Game.new(@game_path)
    @team = Team.new(@team_path, @game_teams_path, @game_path)
    @game_teams = GameTeams.new(@game_teams_path, @game_path, @team_path)
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def highest_total_score 
    @game.highest_total_score
  end

  def lowest_total_score 
    @game.lowest_total_score
  end

  def percentage_home_wins 
    @game.percentage_home_wins
  end

  def percentage_visitor_wins 
    @game.percentage_visitor_wins
  end

	def percentage_ties 
    @game.percentage_ties
	end

	def count_of_games_by_season 
    @game.count_of_games_by_season
	end
   
  def average_goals_per_game 
    @game.average_goals_per_game
  end

  def average_goals_by_season 
    @game.average_goals_by_season
  end

  def count_of_teams 
    @team.count_of_teams
  end

  def best_offense 
    @team.best_offense
  end

  def worst_offense 
    @team.worst_offense
  end

	def highest_scoring_visitor 
    @game_teams.highest_scoring_visitor
	end

	def lowest_scoring_visitor 
    @game_teams.lowest_scoring_visitor
	end

	def highest_scoring_home_team 
    @game_teams.highest_scoring_home_team
	end

	def lowest_scoring_home_team 
    @game_teams.lowest_scoring_home_team
	end

  def winningest_coach(season_id) 
    @game_teams.winningest_coach(season_id)
  end

  def worst_coach(season_id)
    @game_teams.worst_coach(season_id)
  end

  def most_accurate_team(season_id) 
    @game_teams.most_accurate_team(season_id)
  end

  def least_accurate_team(season_id) 
    @game_teams.least_accurate_team(season_id)
  end

  def most_tackles(season_id) 
    @game_teams.most_tackles(season_id)
  end

  def fewest_tackles(season_id) 
    @game_teams.fewest_tackles(season_id)
  end

  def team_info(team_id)
    @team.team_info(team_id)
  end

  def best_season(team_id) 
    @game_teams.best_season(team_id)
  end

  def worst_season(team_id) 
    @game_teams.worst_season(team_id)
  end

  def average_win_percentage(team_id)
    @game_teams.average_win_percentage(team_id)
  end

  def most_goals_scored(team_id)  
    @game_teams.most_goals_scored(team_id)
  end

  def fewest_goals_scored(team_id) 
    @game_teams.fewest_goals_scored(team_id)
  end

  def favorite_opponent(team_id)
    @team.favorite_opponent(team_id)
  end

  def rival(team_id)
    @team.rival(team_id)
  end
end
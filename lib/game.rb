require 'csv'

class Game 
  include Helpable
  include Groupable

   attr_reader :game_path 

  def initialize(file_path)
    @game_path = file_path
  end

  def all_scores 
    @game_path.map do |row|
      row[:away_goals].to_i + row[:home_goals].to_i
    end
  end

  def highest_total_score 
    all_scores.max
  end

  def lowest_total_score 
    all_scores.min
  end

  def percentage_home_wins 
    wins = home_wins_array.count
    (wins.to_f / @game_path.count).round(2)
  end

  def percentage_visitor_wins  
    visitor_wins = visitor_wins_array.count
    (visitor_wins.to_f / @game_path.count).round(2)
  end

	# def ties_array #helper
	# 	@game_path.find_all do |row|
	# 		row[:away_goals].to_i == row[:home_goals].to_i
	# 	end
	# end

	def percentage_ties  
		ties = ties_array.count
		(ties.to_f / @game_path.count).round(2)
	end
   
  def average_goals_per_game 
    (all_scores.sum / @game_path.count.to_f).round(2)
  end

  def average_goals_by_season 
    games_group_by_season = @game_path.group_by { |row| row[:season] }
    average_season_goals = {}
    games_group_by_season.each do |season, games|
     total_goals = games.sum do |game|
        game[:away_goals].to_i + game[:home_goals].to_i
      end
      average_season_goals[season] = (total_goals / games.count.to_f).round(2)
    end
    average_season_goals
  end
end
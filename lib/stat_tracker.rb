require 'csv'
class StatTracker
  attr_reader :game_path,
              :team_path,
              :game_teams_path

  def initialize(locations)
    @game_path = CSV.read(locations[:games], headers: true, skip_blanks: true, header_converters: :symbol)
    @team_path = CSV.read(locations[:teams], headers: true, skip_blanks: true, header_converters: :symbol)
    @game_teams_path = CSV.read(locations[:game_teams], headers: true, skip_blanks: true, header_converters: :symbol)
    
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def all_scores #HELPER for highest_total_score and lowest_total_score
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

  def home_wins_array #HELPER for percentage_home_wins
    @game_path.find_all do |row|
     row[:home_goals].to_i > row[:away_goals].to_i
    end
  end

  def percentage_home_wins 
    wins = home_wins_array.count
    (wins.to_f / @game_path.count).round(2)
  end

  def visitor_wins_array #HELPER for percentage_visitor_wins
    @game_path.find_all do |row|
        row[:away_goals].to_i > row[:home_goals].to_i
    end
  end

  def percentage_visitor_wins
    visitor_wins = visitor_wins_array.count
    (visitor_wins.to_f / @game_path.count).round(2)
  end

	def ties_array #Helper percentage_ties
		@game_path.find_all do |row|
			row[:away_goals].to_i == row[:home_goals].to_i
		end
	end

	def percentage_ties
		ties = ties_array.count
		(ties.to_f / @game_path.count).round(2)
	end

	def count_of_games_by_season
		season_id = @game_path.group_by { |row| row[:season] }
		season_id.each do |season, game|
			season_id[season] = game.count
		end
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

  def average_goals_by_team_hash #HELPER for best and worst offense methods
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



  #--------------------------------------------------

  def games_by_season
    @games_by_season ||= @game_path.group_by do |row|
      row[:season] 
    end
  end

  def games_by_game_id
    #memoization this @games_by_game_id ||= [everything below]
    @games_by_game_id ||= @game_teams_path.group_by do |row| 
      row[:game_id]
    end
  end

  def game_ids_by_season(season_id)
    games_by_season[season_id].map do |games|
      games[:game_id]
    end
  end

  def wins_by_coach(game_id_array) #HELPER for winningest and worst coach
    hash = Hash.new{|k, v| k[v] = []}
    game_id_array.each do |game_id|
      next if games_by_game_id[game_id].nil?
      games_by_game_id[game_id].each do |game|
        hash[game[:head_coach]] << game[:result]
      end
    end
    hash 
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

  #-------------------------------

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

  def teams_with_tackles(games_array) #HELPER fot most and fewest tackles
    hash = Hash.new{|k,v| k[v] = []}
    games_array.each do |game_id|
    next if games_by_game_id[game_id].nil?
      games_by_game_id[game_id].each do |game|
        hash[game[:team_id]] << game[:tackles].to_i
      end
    end
      hash
  end

  def all_scores_by_team #HELPER for most and fewest goals scored by
    hash = Hash.new{|k,v| k[v] = []}
    @game_teams_path.each do |row| 
      hash[row[:team_id]] << row[:goals].to_i
    end
    hash
  end

  def most_goals_scored(team_id)
    all_scores_by_team[team_id.to_s].max
  end

  def fewest_goals_scored(team_id)
    all_scores_by_team[team_id.to_s].min
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

  
end
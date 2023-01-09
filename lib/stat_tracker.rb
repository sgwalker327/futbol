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
 
 def teams_by_id
   @game_teams_path.group_by do |row|
     row[:team_id]
   end
 end
 
 def games_by_id_game_path
   @games_by_id_game_path ||= @game_path.group_by do |row|
     row[:game_id]
   end
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
   best_season_hash = {}
   best = pair_season_with_results_by_team(team_id)
 
   best.each do |season, results|
     best_season_hash[season] = results.count("WIN") / results.count.to_f
   end 

   avg = (best_season_hash.values.sum / best_season_hash.count.to_f).round(2)
 end

 def favorite_opponent(team_id)
  sorted = average_win_percentage_all_teams(team_id).sort_by { |teamid, percentage| percentage}
   
  new_results = sorted.take_while do |team_avg_pair| 
    team_avg_pair[0] != team_id
  end
  
  lowest_win = new_results.reverse.min_by {|arr| arr[1]}
  
  lowest_win_team = @team_path.find do |row| 
    row[:team_id] == lowest_win[0]
  end

  lowest_win_team[:teamname]
 end

 def rival(team_id)
    sorted = win_percentage_all_teams.to_a.sort_by { |teamid, percentage| percentage}
  
   #sorted = average_win_percentage_all_teams(team_id).sort_by{|k, v| v}
  
  new_results = sorted.take_while do |team_avg_pair| 
    team_avg_pair[0] != team_id
  end
  
 
  # new_results = sorted.drop_while do |team_avg_pair| 
  
  #   team_avg_pair[0] == team_id
  # end
  
  biggest_win = new_results.max_by {|arr| arr[1]}
   
  biggest_win_team = @team_path.find do |row| 
     row[:team_id] == biggest_win[0]
  end
  
  biggest_win_team[:teamname]
 end

 def home_teams_by_id_game_path 
  @game_path.map do |row| 
    row[:home_team_id]
  end
 end

 def away_teams_by_id_game_path 
  @game_path.map do |row| 
    row[:away_team_id]
  end
 end

 def zip_home_away_teams 
  zipped = home_teams_by_id_game_path.zip(away_teams_by_id_game_path)
 end

 def win_percentage_all_teams # helper, maybe..?
  hash = Hash.new{|k,v| k[v] = []}

  teams_by_id.each do |team, games| 
    games.each do |game| 
        hash[team] << game[:result] 
      end
    end

    hash.each do |team, result| 
      hash[team] = (result.count("WIN") / (result.count.to_f / 2))
    end 
  hash 
end

def average_win_percentage_all_teams(team_id) #helper for rival and fav opponent
  hash = Hash.new{|k,v| k[v] = 0}
  
    teams_by_id_game_path[team_id].each do |row|
      zip_home_away_teams.each do |zip_pair| 
      
      #  if (zip_pair.include?(row[:away_team_id]) || zip_pair.include?(row[:home_team_id])) && zip_pair.include?(team_id)
       if zip_pair.include?(team_id) && (zip_pair.include?(row[:away_team_id]) || zip_pair.include?(row[:home_team_id]))
      
        if row[:away_goals].to_i > row[:home_goals].to_i 
            hash[row[:away_team_id]] += 1
        else
           hash[row[:home_team_id]] += 1
        end
      end 
    end
  end
  
    hash.each do |team, results|  
      hash[team] = (results / teams_by_id_game_path[team_id].count.to_f)
    end
  hash 
 end


 def teams_by_id_game_path #helper for avg_win_%_all_teams
  @teams_by_id_game_path ||= @game_path.group_by do |row| 
    row[:away_team_id]
  end
 end
end
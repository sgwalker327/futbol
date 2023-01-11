module Groupable 
    def games_by_game_id
    @games_by_game_id ||= @game_teams_path.group_by do |row| 
      row[:game_id]
    end
  end

  def games_by_season
    @games_by_season ||= @game_path.group_by do |row|
      row[:season] 
    end
  end

   def teams_by_id
    @teams_by_id ||= @game_teams_path.group_by do |row|
      row[:team_id]
    end
  end

  def games_by_id_game_path
    @games_by_id_game_path ||= @game_path.group_by do |row|
      row[:game_id]
    end
  end

  def games_by_team_id 
    @games_by_team_id ||= @game_teams_path.group_by do |row|
      row[:team_id]
    end
  end

  def get_ratios_by_season_id(season_id)
    merged_hash = team_shots_by_season(season_id).merge(team_goals_by_season(season_id)) {|key, old_val, new_val| new_val.sum / old_val.sum.to_f}
  end

  def game_ids_by_season(season_id) 
    games_by_season[season_id].map do |games|
      games[:game_id]
    end
  end

  def all_scores_by_team 
    hash = Hash.new{|k,v| k[v] = []}
    @game_teams_path.each { |row| hash[row[:team_id]] << row[:goals].to_i }
    hash
  end

 def team_name_by_team_id(team_id)
    @team_path.find do |team|
      team[:team_id] == team_id
    end[:teamname]
  end
end
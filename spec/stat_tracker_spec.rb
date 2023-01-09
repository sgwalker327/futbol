require_relative 'spec_helper'

RSpec.describe StatTracker do
  before(:all) do
    game_path = './spec/fixtures/games_fixture.csv'
    team_path = './spec/fixtures/teams_fixture.csv'
    game_teams_path = './spec/fixtures/game_teams_fixture.csv'

    # game_path = './data/games.csv'
    # team_path = './data/teams.csv'
    # game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(locations)
  end
 
  it "exists" do 
   expect(@stat_tracker).to be_an_instance_of(StatTracker)
  end
  
  describe '#highest_total_score' do 
    it 'returns the highest sum of the winning and losing teams scores' do 
      expect(@stat_tracker.highest_total_score).to eq(6)
    end
  end

  describe '#lowest_total_score' do 
    it ' is the lowest sum of the wining and losing teams scores' do 
      expect(@stat_tracker.lowest_total_score).to eq(1)
    end
  end

  describe '#all_scores' do 
    it 'is a helper method for highest and lowest total score methods' do 
      expect(@stat_tracker.all_scores.class).to eq(Array)
    end
  end

  describe '#percentage_home_wins' do 
    it 'is the percentage of games that a home team has won' do 
      expect(@stat_tracker.percentage_home_wins).to eq(0.53)
    end
  end

  describe '#home_wins_array' do 
    it 'is a helper method for percentage_home_wins, array of home goals greater than away goals' do 
      expect(@stat_tracker.home_wins_array.class).to eq(Array)
    end
  end
  
  describe '#percentage_visitor_wins' do 
    it 'returns percentage of games a visitor has won' do 
      expect(@stat_tracker.percentage_visitor_wins).to eq(0.27)
    end
  end

  describe '#visitor_wins_array' do 
    it 'returns array of games visitors have won' do 
      expect(@stat_tracker.visitor_wins_array.class).to eq(Array)
    end
  end

  describe '#percentage_ties' do 
    it 'returns percentage of games that hace result in a tie' do 
      expect(@stat_tracker.percentage_ties).to eq(0.2)
    end
  end

  describe '#ties_array' do 
    it 'returns an array of games that have resulted in a tie' do 
      expect(@stat_tracker.ties_array.class).to eq(Array)
    end
  end
   
  describe '#count_of_games_by_season' do 
    it 'returns a hash with season names as keys and counts of games as values' do 
      expected = {
        "20122013" => 22,
        "20132014" => 8
      }
      expect(@stat_tracker.count_of_games_by_season).to eq(expected)
    end
  end
  
  describe '#average_goals_per_game' do
    it 'finds the average number of goals per game' do
      expect(@stat_tracker.average_goals_per_game).to eq(4.00)
    end
  end

  describe '#average_goals_by_season' do
    it 'finds the average goals per game per season' do
      expect(@stat_tracker.average_goals_by_season.class).to eq(Hash)
      expect(@stat_tracker.average_goals_by_season).to eq(
        {"20122013"=>4.05, "20132014"=>3.88} )
    end
  end

  describe '#count_of_teams' do
    it 'finds the total number of teams' do
      expect(@stat_tracker.count_of_teams).to eq(32)
    end
  end

  describe '#best_offense' do 
    it 'is the name of the team with the highest average number of goals scored per game across all seasons' do 
      expect(@stat_tracker.best_offense).to eq("FC Dallas")
    end
  end

  describe '#worst_offense' do 
    it 'is the name of the team with the lowest average number of goals scored per game across all seasons.' do 
      expect(@stat_tracker.worst_offense).to eq("Sporting Kansas City")
    end
  end

  describe '#average_goals_by_team_hash' do 
    it 'is a helper method to group the teams to their average goals' do 
      expect(@stat_tracker.average_goals_by_team_hash.class).to eq(Hash)
    end
  end

  describe '#visitor_scores_hash' do 
    it 'returns a hash with the team id as the key and the value as the average score' do 
      expect(@stat_tracker.visitor_scores_hash.class).to eq(Hash)
    end
  end

  describe '#highest_scoring_visitor' do 
    it 'returns a string of the highest scoring away team name' do 
      expect(@stat_tracker.highest_scoring_visitor).to eq("FC Dallas")
    end
  end

  describe '#lowest_scoring_visitor' do 
    it 'returns a string of the lowest scoring away team name' do 
      expect(@stat_tracker.lowest_scoring_visitor).to eq("Sporting Kansas City")
    end
  end

  describe '#highest_scoring_home_team' do
    it 'returns a string of the highest scoring home team' do 
      expect(@stat_tracker.highest_scoring_home_team).to eq("New York City FC")
    end
  end

  describe '#lowest_scoring_home_team' do
    it 'returns a string of the lowest scoring home team' do 
      expect(@stat_tracker.lowest_scoring_home_team).to eq("Sporting Kansas City")
    end
  end

  describe '#winningest_coach' do 
    it 'is coach with most wins of the season' do
      expect(@stat_tracker.winningest_coach("20122013")).to eq("Claude Julien")
    end
  end

  describe '#worst_coach' do 
    it 'is the coach with the least wins of the season' do 
      expect(@stat_tracker.worst_coach("20122013")).to eq("Dan Bylsma")
    end
  end

  describe '#games_by_season' do 
    it 'is a helper method that groups the games by the season' do 
      expect(@stat_tracker.games_by_season.class).to eq(Hash)
    end
  end

  describe '#games_by_game_id' do 
    it 'is a helper method that groups the games by the game_id' do 
      expect(@stat_tracker.games_by_game_id.class).to eq(Hash)
    end
  end

  describe '#game_ids_by_season' do 
    it 'is a helper method that groups game ids to the give season' do 
      expect(@stat_tracker.game_ids_by_season("20122013").class).to eq(Array)
    end
  end

  describe '#most_tackles' do 
    it 'is the team with the most tackles in the season' do 
      expect(@stat_tracker.most_tackles("20122013")).to eq("FC Dallas")
    end
  end

  describe '#fewest_tackles' do 
    it 'is the team with the fewest tackles' do 
      expect(@stat_tracker.fewest_tackles("20122013")).to eq("New England Revolution")
    end
  end 

  describe '#teams_with_tackles' do 
    it 'is a helper method to set team ids to their array of tackles' do 
      expect(@stat_tracker.teams_with_tackles([]).class).to eq(Hash)
    end
  end

  describe '#wins_by_coach' do 
    it 'is a helper method to group the coach and their wins in a hash' do 
      expect(@stat_tracker.wins_by_coach([]).class).to eq(Hash)
    end
  end

  describe '#most_goals_scored' do 
    it 'is the most goals scored by a given team' do 
      expect(@stat_tracker.most_goals_scored(3)).to eq(2)
    end
  end

  describe 'fewest_goals_scored' do 
    it 'is the lowest score by the given team' do 
      expect(@stat_tracker.fewest_goals_scored(3)).to eq(1)
    end
  end

  describe '#all_scores_by_team' do 
    it 'is a helper method to pair all the scores a team has' do 
      expect(@stat_tracker.all_scores_by_team.class).to eq(Hash)
    end
  end

  describe '#get_ratios_by_team_id' do 
    it 'gets the ratios by the team' do 
      expect(@stat_tracker.get_ratios_by_season_id('20122013').class).to eq(Hash)
    end
  end

  describe '#most_accurate_teams' do 
    it 'is the team that is the most accurate' do 
      expect(@stat_tracker.most_accurate_team("20122013")).to eq("FC Dallas")
    end
  end

  describe '#least_accurate_teams' do
    it 'is the team that is the least accurate' do
      expect(@stat_tracker.most_accurate_team("20122013")).to eq("FC Dallas")
    end
  end

  describe '#team_shots_by_season' do
    it 'gives the total team shots by season' do
      expect(@stat_tracker.team_shots_by_season("20122013").class).to eq(Hash)
    end
  end

  describe '#team_goals_by_season' do
    it 'gives the total team goals by season' do
      expect(@stat_tracker.team_goals_by_season("20122013").class).to eq(Hash)
    end
  end

  describe '#team_info' do 
    it 'is team info' do 
      expected = {
        "team_id"=>"6", 
        "franchise_id"=>"6",
        "team_name"=>"FC Dallas", 
        "abbreviation"=>"DAL",
        "link"=>"/api/v1/teams/6"
      }

      expect(@stat_tracker.team_info("6")).to eq(expected)
    end
  end

  describe '#pair_teams_with_results' do 
    it 'pairs the teams with their win and game id' do 
      expect(@stat_tracker.pair_teams_with_results("6").class).to eq(Hash)
    end
  end

  describe '#pair_season_with_results_by_team' do 
    it 'is a sandbox' do 
      expect(@stat_tracker.pair_season_with_results_by_team("6").class).to eq(Hash)
    end
  end

  describe '#best_season' do 
    it 'is the best season for a team' do 
      expect(@stat_tracker.best_season("6")).to eq("20122013")
    end
  end

  describe '#team_info' do
   it 'is team info' do
     expected = {
       "team_id"=>"6",
       "franchise_id"=>"6",
       "team_name"=>"FC Dallas",
       "abbreviation"=>"DAL",
       "link"=>"/api/v1/teams/6"
     }
 
     expect(@stat_tracker.team_info("6")).to eq(expected)
   end
 end
 
 describe '#pair_teams_with_results' do
   it 'pairs the teams with their win and game id' do
     expect(@stat_tracker.pair_teams_with_results("6").class).to eq(Hash)
   end
 end
 
 describe '#pair_season_with_results_by_team' do
   it 'is a sandbox' do
     expect(@stat_tracker.pair_season_with_results_by_team("6").class).to eq(Hash)
   end
 end
 
 describe '#best_season' do
   it 'is the best season for a team' do
     expect(@stat_tracker.best_season("6")).to eq("20122013")
   end
 end

 describe '#worst_season' do
   it 'is the best season for a team' do
     expect(@stat_tracker.worst_season("6")).to eq("20122013")
   end
 end

 xdescribe '#average_win_percentage' do 
  it ' is the average win percentage for the team' do 
    expect(@stat_tracker.average_win_percentage("6")).to eq("")
  end
 end

 describe '#favorite_opponent' do 
  it 'is the name of the team that has lowest win percentage against given team' do 
    expect(@stat_tracker.favorite_opponent("16")).to eq("Toronto FC")
  end
 end

 xdescribe '#average_win_percentage_all_teams' do 
  it 'pairs all team with their average win percentage' do 
    expect(@stat_tracker.average_win_percentage_all_teams("5")).to eq("")
  end
 end

 describe '#zip_home_away_teams' do 
  it 'zips the home and away team ids' do 
    expect(@stat_tracker.zip_home_away_teams.class).to eq(Array)
    expect(@stat_tracker.zip_home_away_teams.count).to eq(30)
  end
 end

 describe '#rival' do 
  it '...help' do 
    expect(@stat_tracker.rival("16")).to eq("New York Red Bulls")
  end
 end
end
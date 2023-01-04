require_relative 'spec_helper'

RSpec.describe StatTracker do
  before(:all) do
    game_path = './spec/fixtures/games_fixture.csv'
    team_path = './spec/fixtures/teams_fixture.csv'
    game_teams_path = './spec/fixtures/game_teams_fixture.csv'

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
end
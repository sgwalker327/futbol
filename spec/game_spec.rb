require_relative 'spec_helper'

RSpec.describe Game do
  before(:all) do
   
  game_path = 'spec/fixtures/games_fixture.csv'

    locations = {
      games: game_path
    }

    @game_path = CSV.read(locations[:games], headers: true, skip_blanks: true, header_converters: :symbol)
    @game = Game.new(@game_path)
  end

  describe '#all_scores' do 
    it 'is a helper method for highest and lowest total score' do 
      expect(@game.all_scores.count).to eq(30)
    end
  end

  describe '#highest_total_score' do 
    it 'returns the highest sum of the winning and losing teams scores' do 
      expect(@game.highest_total_score).to eq(6)
    end
  end

  describe '#lowest_total_score' do 
    it ' is the lowest sum of the wining and losing teams scores' do 
      expect(@game.lowest_total_score).to eq(1)
    end
  end

  describe '#percentage_home_wins' do 
    it 'is the percentage of games that a home team has won' do 
      expect(@game.percentage_home_wins).to eq(0.53)
    end
  end

  describe '#home_wins_array' do 
    it 'is a helper method for percentage_home_wins, array of home goals greater than away goals' do 
      expect(@game.home_wins_array.class).to eq(Array)
      expect(@game.home_wins_array.count).to eq(16)
      expect(@game.home_wins_array[0]).to include(:game_id, :away_team_id)
    end
  end
  
  describe '#percentage_visitor_wins' do 
    it 'returns percentage of games a visitor has won' do 
      expect(@game.percentage_visitor_wins).to eq(0.27)
    end
  end

  describe '#visitor_wins_array' do 
    it 'returns array of games visitors have won' do 
      expect(@game.visitor_wins_array.class).to eq(Array)
      expect(@game.visitor_wins_array.count).to eq(8)
      expect(@game.visitor_wins_array[0]).to include(:game_id)
    end
  end

  describe '#percentage_ties' do 
    it 'returns percentage of games that hace result in a tie' do 
      expect(@game.percentage_ties).to eq(0.2)
    end
  end

  describe '#ties_array' do 
    it 'returns an array of games that have resulted in a tie' do 
      expect(@game.ties_array.class).to eq(Array)
      expect(@game.ties_array.count).to eq(6)
      expect(@game.ties_array[0]).to include(:season, :game_id)
    end
  end

  describe '#count_of_games_by_season' do 
    it 'returns a hash with season names as keys and counts of games as values' do 
      expected = {
        '20122013' => 22,
        '20132014' => 8
      }
      expect(@game.count_of_games_by_season).to eq(expected)
    end
  end

  describe '#average_goals_per_game' do
    it 'finds the average number of goals per game' do
      expect(@game.average_goals_per_game).to eq(4.00)
    end
  end

  describe '#average_goals_by_season' do
    it 'finds the average goals per game per season' do
      expect(@game.average_goals_by_season.class).to eq(Hash)
      expect(@game.average_goals_by_season).to eq( {'20122013'=>4.05, '20132014'=>3.88} )
    end
  end  
end

  
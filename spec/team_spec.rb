require_relative 'spec_helper'

RSpec.describe Team do 
  before(:all) do
    game_path = './spec/fixtures/games_fixture.csv'
    team_path = './spec/fixtures/teams_fixture.csv'
    game_teams_path = './spec/fixtures/game_teams_fixture.csv'

    locations = {
      teams: team_path,
      games: game_path,
      game_teams: game_teams_path
    }

    @game_path = CSV.read(locations[:games], headers: true, skip_blanks: true, header_converters: :symbol)
    @team_path = CSV.read(locations[:teams], headers: true, skip_blanks: true, header_converters: :symbol)
    @game_teams_path = CSV.read(locations[:game_teams], headers: true, skip_blanks: true, header_converters: :symbol)
    @team = Team.new(@team_path, @game_teams_path, @game_path)
  end

  describe '#initialize' do
    it 'exists' do 
      expect(@team).to be_a(Team)
    end
  end

  describe '#count_of_teams' do 
    it 'counts all teams in file and returns an integer' do 
      expect(@team.count_of_teams).to eq(32)
      expect(@team.count_of_teams).to be_a(Integer)
    end
  end

  describe '#average_goals_by_team_hash' do 
    it 'is a helper method to group the teams to their average goals' do 
      expected = {
                  '3'=>1.6, 
                  '6'=>2.67, 
                  '5'=>0.5, 
                  '17'=>1.86, 
                  '16'=>1.43, 
                  '9'=>2.5, 
                  '8'=>2.0
                }
      expect(@team.average_goals_by_team_hash).to eq(expected)
      expect(@team.average_goals_by_team_hash).to be_a(Hash)
    end
  end

  describe '#best_offense' do 
    it 'returns name of the team with the highest average number of goals scored per game across all seasons' do 
      expect(@team.best_offense).to eq('FC Dallas')
    end
  end

  describe '#worst_offense' do 
    it 'returns the name of the team with the lowest average number of goals scored per game across all seasons.' do 
      expect(@team.worst_offense).to eq('Sporting Kansas City')
    end
  end

  describe '#home_scores_hash' do 
    it 'returns a hash of the average home goals per team' do 
      expected = {
                  '3'=>0.6, 
                  '6'=>1.33, 
                  '5'=>0.25, 
                  '17'=>1.14, 
                  '16'=>1.0, 
                  '9'=>1.75, 
                  '8'=>1.25
                }
      expect(@team.home_scores_hash).to be_a(Hash)
      expect(@team.home_scores_hash).to eq(expected)
    end
  end

  describe '#visitor_scores_hash' do 
    it 'returns a hash of the average visitor goals per team' do 
      expected = {
                  '3'=>1.0, 
                  '6'=>1.33, 
                  '5'=>0.25, 
                  '17'=>0.71, 
                  '16'=>0.43, 
                  '9'=>0.75, 
                  '8'=>0.75
                }
      expect(@team.visitor_scores_hash).to be_a(Hash)
      expect(@team.visitor_scores_hash).to eq(expected)
    end
  end

  describe '#highest_scoring_visitor' do 
    it 'returns a string of the highest scoring away team name' do 
      expect(@team.highest_scoring_visitor).to eq('FC Dallas')
    end
  end

  describe '#lowest_scoring_visitor' do 
    it 'returns a string of the lowest scoring away team name' do 
      expect(@team.lowest_scoring_visitor).to eq('Sporting Kansas City')
    end
  end

   describe '#highest_scoring_home_team' do
    it 'returns a string of the highest scoring home team' do 
      expect(@team.highest_scoring_home_team).to eq('New York City FC')
    end
  end

  describe '#lowest_scoring_home_team' do
    it 'returns a string of the lowest scoring home team' do 
      expect(@team.lowest_scoring_home_team).to eq('Sporting Kansas City')
    end
  end

   describe '#games_by_season' do 
    it 'is a helper method that groups the games by the season' do 
      expect(@team.games_by_season.class).to eq(Hash)
    end
  end

  describe '#games_by_game_id' do 
    it 'is a helper method that groups the games by the game_id' do 
      expect(@team.games_by_game_id.class).to eq(Hash)
    end
  end

  describe '#game_ids_by_season' do 
    it 'is a helper method that groups game ids to the give season' do
       expected = ['2012030221', '2012030222', '2012030223', '2012030224', '2012030225', '2012030311', '2012030312','2012030313', '2012030314', '2012030231', '2012030232', '2012030233', '2012030234', '2012030235', '2012030236', '2012020225', '2012020577', '2012020122', '2012020387','2012020510', '2012020511', '2012020116']
      expect(@team.game_ids_by_season('20122013')).to be_a(Array)
      expect(@team.game_ids_by_season('20122013')).to eq(expected)
    end
  end

describe '#most_tackles' do 
  it 'is the team with the most tackles in the season' do 
    expect(@team.most_tackles('20122013')).to eq('FC Dallas')
  end
end

describe '#fewest_tackles' do 
  it 'is the team with the fewest tackles' do 
    expect(@team.fewest_tackles('20122013')).to eq('New England Revolution')
  end
end 

describe '#teams_with_tackles' do 
  it 'is a helper method to set team ids to their array of tackles' do 
    expect(@team.teams_with_tackles([]).class).to eq(Hash)
    expect(@team.teams_with_tackles([]).count).to eq(0)
  end
end

  describe '#team_shots_by_season' do
    it 'gives the total team shots by season' do
      expected = {
                  '3'=>[8, 9, 6, 8, 7], 
                  '6'=>[12, 8, 8, 10, 8, 7, 7, 10, 6], 
                  '5'=>[7, 6, 13, 6], 
                  '17'=>[5, 7, 7, 6, 6, 9], 
                  '16'=>[10, 5, 10, 7, 11, 7]
                }
      expect(@team.team_shots_by_season('20122013')).to be_a(Hash)
      expect(@team.team_shots_by_season('20122013')).to eq(expected)
    end
  end

  describe '#get_ratios_by_season_id' do 
    it 'gets the ratios by the team' do
       expected = {
                    '3'=>0.21052631578947367, 
                    '6'=>0.3157894736842105, 
                    '5'=>0.0625, 
                    '17'=>0.3, 
                    '16'=>0.16
                  }
      expect(@team.get_ratios_by_season_id('20122013')).to be_a(Hash)
      expect(@team.get_ratios_by_season_id('20122013')).to eq(expected)
    end
  end

    describe '#most_accurate_team' do 
    it 'is the team that is the most accurate' do 
      expect(@team.most_accurate_team('20122013')).to eq('FC Dallas')
    end
  end

  describe '#least_accurate_team' do
    it 'is the team that is the least accurate' do
      expect(@team.most_accurate_team('20122013')).to eq('FC Dallas')
    end
  end

   describe '#team_goals_by_season' do
    it 'gives the total team goals by season' do
      expected = {
                  '3'=>[2, 2, 1, 2, 1], 
                  '6'=>[3, 3, 2, 3, 3, 3, 4, 2, 1], 
                  '5'=>[0, 1, 1, 0], 
                  '17'=>[1, 2, 3, 2, 1, 3], 
                  '16'=>[2, 1, 1, 0, 2, 2]
                }
      expect(@team.team_goals_by_season('20122013')).to be_a(Hash)
      expect(@team.team_goals_by_season('20122013')).to eq(expected)
    end
  end

  describe '#team_info' do 
    it 'is team info' do 
      expected = {
        'team_id'=>'6', 
        'franchise_id'=>'6',
        'team_name'=>'FC Dallas', 
        'abbreviation'=>'DAL',
        'link'=>'/api/v1/teams/6'
      }

      expect(@team.team_info('6')).to eq(expected)
    end
  end
  describe '#games_by_team_id' do 
    it 'returns a hash with the game id as the key with games as values' do 
      expect(@team.games_by_team_id.class).to eq(Hash)
    end
  end

  describe '#team_name_by_team_id' do 
    it 'returns a hash with the game id as the key with games as values' do 
      expect(@team.team_name_by_team_id('6')).to be_a(String)
    end
  end

  describe '#win_average_helper' do 
    it 'returns an array'do 
    expect(@team.win_average_helper('3')).to be_a(Array)
    expect(@team.win_average_helper('3').count).to eq(1)
    end
  end

   describe '#favorite_opponent' do
    it 'is the name of the team that has lowest win percentage against given team' do
      expect(@team.favorite_opponent("3")).to eq("FC Dallas")
    end
  end

  describe '#rival' do
    it 'is the name of the team that has highest win percentage against given team' do
      expect(@team.favorite_opponent("3")).to eq("FC Dallas")
    end
  end

end
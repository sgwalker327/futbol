require_relative 'spec_helper'

RSpec.describe GameTeams do
  before(:all) do
    game_teams_path = './spec/fixtures/game_teams_fixture.csv'
    game_path = './spec/fixtures/games_fixture.csv'
    team_path = './spec/fixtures/teams_fixture.csv'

    locations = {
      game_teams: game_teams_path,
      games: game_path,
      teams: team_path
    }

    @game_teams_path = CSV.read(locations[:game_teams], headers: true, skip_blanks: true, header_converters: :symbol)
    @game_path = CSV.read(locations[:games], headers: true, skip_blanks: true, header_converters: :symbol)
    @team_path = CSV.read(locations[:teams], headers: true, skip_blanks: true, header_converters: :symbol)
    @game_teams = GameTeams.new(@game_teams_path, @game_path, @team_path)
  end
  
  describe '#initialize' do
    it 'exists' do 
      expect(@game_teams).to be_an_instance_of(GameTeams)
    end
  end
  
  describe '#average_goals_by_team_hash' do 
    it 'is a helper method to group the teams to their average goals' do 
      expect(@game_teams.average_goals_by_team_hash.class).to eq(Hash)
      expect(@game_teams.average_goals_by_team_hash.count).to eq(7)
    end
  end

  describe '#visitor_scores_hash' do 
    it 'returns a hash with the team id as the key and the value as the average score' do 
      expect(@game_teams.visitor_scores_hash.class).to eq(Hash)
      expect(@game_teams.visitor_scores_hash.count).to eq(7)
    end
  end

  describe '#home_scores_hash' do 
    it 'returns a hash with the team id as the key and the value as the average score' do 
      expect(@game_teams.home_scores_hash.class).to eq(Hash)
      expect(@game_teams.home_scores_hash.count).to eq(7)
    end
  end

  describe '#highest_scoring_visitor' do 
    it 'returns a string of the highest scoring away team name' do 
      expect(@game_teams.highest_scoring_visitor).to eq('FC Dallas')
    end
  end

  describe '#lowest_scoring_visitor' do 
    it 'returns a string of the lowest scoring away team name' do 
      expect(@game_teams.lowest_scoring_visitor).to eq('Sporting Kansas City')
    end
  end

  describe '#highest_scoring_home_team' do
    it 'returns a string of the highest scoring home team' do 
      expect(@game_teams.highest_scoring_home_team).to eq('New York City FC')
    end
  end

  describe '#lowest_scoring_home_team' do
    it 'returns a string of the lowest scoring home team' do 
      expect(@game_teams.lowest_scoring_home_team).to eq('Sporting Kansas City')
    end
  end

  describe '#games_by_season' do 
    it 'is a helper method that groups the games by the season' do
      expect(@game_teams.games_by_season.class).to eq(Hash)
      expect(@game_teams.games_by_season.count).to eq(2)
    end
  end
  
  describe '#games_by_game_id' do 
  it 'is a helper method that groups the games by the game_id' do 
      expect(@game_teams.games_by_game_id.class).to eq(Hash)
      expect(@game_teams.games_by_game_id.count).to eq(20)
    end
  end

  describe '#game_ids_by_season' do 
    it 'is a helper method that groups game ids to the give season' do
      expected = ["2012030221", "2012030222", "2012030223", "2012030224", "2012030225", 
                  "2012030311", "2012030312", "2012030313", "2012030314", "2012030231", 
                  "2012030232", "2012030233", "2012030234", "2012030235", "2012030236",
                  "2012020225", "2012020577", "2012020122", "2012020387", "2012020510", 
                  "2012020511", "2012020116"]
      expect(@game_teams.game_ids_by_season('20122013')).to eq(expected)
      expect(@game_teams.game_ids_by_season('20122013').class).to eq(Array)
      expect(@game_teams.game_ids_by_season('20122013').count).to eq(22)
    end
  end

  describe '#most_tackles' do 
    it 'is the team with the most tackles in the season' do 
      expect(@game_teams.most_tackles('20122013')).to eq('FC Dallas')
    end
  end

  describe '#fewest_tackles' do 
    it 'is the team with the fewest tackles' do 
      expect(@game_teams.fewest_tackles('20122013')).to eq('New England Revolution')
    end
  end 

  describe '#teams_with_tackles' do 
    it 'is a helper method to set team ids to their array of tackles' do
      expect(@game_teams.teams_with_tackles([]).class).to eq(Hash)
      expect(@game_teams.teams_with_tackles([]).count).to eq(0)
    end
  end

  describe '#all_scores_by_team' do 
    it 'is a helper method to pair all the scores a team has' do 
      expect(@game_teams.all_scores_by_team.class).to eq(Hash)
      expect(@game_teams.all_scores_by_team["3"]).to eq([2,2,1,2,1])
      expect(@game_teams.all_scores_by_team.count).to eq(7)
    end
  end

  describe '#most_goals_scored' do 
    it 'is the most goals scored by a given team' do 
      expect(@game_teams.most_goals_scored(3)).to eq(2)
    end
  end

  describe 'fewest_goals_scored' do 
    it 'is the lowest score by the given team' do 
      expect(@game_teams.fewest_goals_scored(3)).to eq(1)
    end
  end

  describe '#get_ratios_by_season_id' do 
    it 'gets the ratios by the season' do
      expected = {"3"=>0.21052631578947367, "6"=>0.3157894736842105, "5"=>0.0625, "17"=>0.3, "16"=>0.16}
      expect(@game_teams.get_ratios_by_season_id('20122013')).to eq(expected)
      expect(@game_teams.get_ratios_by_season_id('20122013').class).to eq(Hash)
    end
  end

  describe '#team_shots_by_season' do
    it 'gives the total team shots by season' do
      expect(@game_teams.team_shots_by_season('20122013').class).to eq(Hash)
      expect(@game_teams.team_shots_by_season('20122013').count).to eq(5)
      expect(@game_teams.team_shots_by_season('20122013').keys).to eq(["3", "6", "5", "17", "16"])
    end
  end

  describe '#team_goals_by_season' do
    it 'gives the total team goals by season' do
      expect(@game_teams.team_goals_by_season('20122013').class).to eq(Hash)
      expect(@game_teams.team_goals_by_season('20122013').count).to eq(5)
      expect(@game_teams.team_goals_by_season('20122013').keys).to eq(["3", "6", "5", "17", "16"])
    end
  end

  describe '#teams_by_id' do
    it 'returns a hash with team id as key and game info as the value' do
      expect(@game_teams.teams_by_id.class).to eq(Hash)
      expect(@game_teams.teams_by_id.count).to eq(7)
    end
  end

  describe '#games_by_id_game_path' do
    it 'returns a hash with the game_id as the key and game infor as the value' do
      expect(@game_teams.games_by_id_game_path.class).to eq(Hash)
      expect(@game_teams.games_by_id_game_path.count).to eq(30)
    end
  end
  
  describe '#pair_teams_with_results' do 
    it 'pairs the teams with their win and game id' do 
      expect(@game_teams.pair_teams_with_results('6').class).to eq(Hash)
      expect(@game_teams.pair_teams_with_results('6').keys).to eq(["6"])
      expect(@game_teams.pair_teams_with_results('6').count).to eq(1)
    end
  end

  describe '#pair_season_with_results_by_team' do 
    it 'returns a hash with the ' do 
      expect(@game_teams.pair_season_with_results_by_team('6').class).to eq(Hash)
      expect(@game_teams.pair_season_with_results_by_team('6').count).to eq(1)
    end
  end

  describe '#best_season' do 
    it 'is the best season for a team' do 
      expect(@game_teams.best_season('6')).to eq('20122013')
    end
  end

  describe '#worst_season' do
    it 'is the best season for a team' do
      expect(@game_teams.worst_season('6')).to eq('20122013')
    end
  end

  describe '#average_win_percentage' do 
    it 'returns average win  percentage of all games for a team' do
      expect(@game_teams.average_win_percentage('6')).to eq(1.0)
    end
  end
end
require 'rails_helper'

RSpec.describe Piece, type: :model do
	context 'Validation test' do
		it 'is valid with valid attributes' do
			user = create(:user)
			sign_in user
			expect(create(:piece)).to be_valid
		end
	end

	describe 'is_obstructed' do 
		it 'returns true if piece is blocking vertical path' do 
			game = FactoryBot.create(:game)
			pieceOne = FactoryBot.create(:piece, x_position: 1, y_position: 2, game_id: game.id)
			pieceTwo = FactoryBot.create(:piece, x_position: 1, y_position: 6, game_id: game.id)
			is_obs = pieceOne.is_obstructed?(1,8)
			is_not_obs = pieceOne.is_obstructed?(1,5)
			expect(is_obs).to be_truthy
			expect(is_not_obs).to be_falsey

		end

		it 'return true if piece is blocking horizontal path' do 
			game = FactoryBot.create(:game)
			pieceOne = FactoryBot.create(:piece, x_position: 1, y_position: 1, game_id: game.id)
			pieceTwo = FactoryBot.create(:piece, x_position: 6, y_position: 1, game_id: game.id)
			is_obs = pieceOne.is_obstructed?(8,1)
			is_not_obs = pieceOne.is_obstructed?(5,1)
			expect(is_obs).to be_truthy
			expect(is_not_obs).to be_falsey
		end

		it 'returns true if piece is blocking diaganol path' do 
			game = FactoryBot.create(:game)
			pieceOne = FactoryBot.create(:piece, x_position: 1, y_position: 1, game_id: game.id)
			pieceTwo = FactoryBot.create(:piece, x_position: 5, y_position: 5, game_id: game.id)
			is_obs = pieceOne.is_obstructed?(6,6)
			is_not_obs = pieceOne.is_obstructed?(3,3)
			expect(is_obs).to be_truthy
			expect(is_not_obs).to be_falsey

		end
	end
end

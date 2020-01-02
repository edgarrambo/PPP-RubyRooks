require 'rails_helper'

RSpec.describe Knight, type: :model do
  describe 'valid_move?' do
    before(:each) do
      @user = create(:user)
      sign_in @user

      @game = create(:game)
    end

    it 'allows a vertical move 2 up and 1 right' do
      knight = create(:knight, x_position: 0, y_position: 1, piece_number: 1, game_id: @game.id)
      expect(knight.valid_move?(1, 3)).to eq true
    end

    it 'allows a vertical move 2 up and 1 left' do
      knight = create(:knight, x_position: 1, y_position: 1, piece_number: 1, game_id: @game.id)
      expect(knight.valid_move?(0, 3)).to eq true
    end

    it 'allows a vertical move 2 down and 1 right' do
      knight = create(:knight, x_position: 0, y_position: 7, piece_number: 1, game_id: @game.id)
      expect(knight.valid_move?(1, 5)).to eq true
    end

    it 'allows a vertical move 2 down and 1 left' do
      knight = create(:knight, x_position: 1, y_position: 7, piece_number: 1, game_id: @game.id)
      expect(knight.valid_move?(0, 5)).to eq true
    end

    it 'allows a horizontal move 2 right and 1 up' do
      knight = create(:knight, x_position: 0, y_position: 1, piece_number: 1, game_id: @game.id)
      expect(knight.valid_move?(2, 2)).to eq true
    end

    it 'allows a horizontal move 2 right and 1 down' do
      knight = create(:knight, x_position: 0, y_position: 1, piece_number: 1, game_id: @game.id)
      expect(knight.valid_move?(2, 0)).to eq true
    end

    it 'allows a horizontal move 2 left and 1 up' do
      knight = create(:knight, x_position: 7, y_position: 1, piece_number: 1, game_id: @game.id)
      expect(knight.valid_move?(5, 2)).to eq true
    end

    it 'allows a horizontal move 2 left and 1 down' do
      knight = create(:knight, x_position: 7, y_position: 1, piece_number: 1, game_id: @game.id)
      expect(knight.valid_move?(5, 0)).to eq true
    end
  end
end

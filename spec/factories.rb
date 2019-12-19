# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    name { 'game' }
  end

  factory :king do
    
  end

  factory :queen do
    
  end

  factory :knight do
    
  end

  factory :rook do
    
  end

  factory :pawn do
    
  end

  factory :piece do
    x_position { 1 }
    y_position { 1 }
    game_id { 1 }
    black { false }
  end

  factory :move do
    
  end

  factory :comment do
    
  end

  factory :position do
    
  end

  factory :user do
    email { 'john@smith.com' }
  end
end

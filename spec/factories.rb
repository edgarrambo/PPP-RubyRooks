# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    name { 'game' }
    game_id { 999 }
  end

  factory :bishop do
    x_position { 0 }
    y_position { 0 }
    black { true }

    association :game
  end

  factory :piece do
    x_position { 1 }
    y_position { 1 }
    game_id { 1 }
    black { false }

    association :game
  end

  factory :move do
    
  end

  factory :comment do
    
  end

  factory :position do
    
  end

  factory :user do
    email { 'john@smith.com' }
    password { 'password' }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    name { 'A-Game' }
  end

  factory :piece do
    x_position { 1 }
    y_position { 1 }
    black { false }

    association :game
  end

  factory :user do
    email { 'john@smith.com' }
    password { 'password' }
  end
end

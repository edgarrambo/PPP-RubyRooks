# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    name { 'A-Game' }

  end

  factory :piece do
    x_position { 1 }
    y_position { 1 }

    association :game
  end

    factory :user do
    sequence(:email, 1000, aliases: [:creating_user, :invited_user, :first_move, :winner]) { |n| "person#{n}@example.com" }
    password { 'password' }
  end
  
end

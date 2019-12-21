# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    name { 'A-Game' }

    association :creating_user, factory: :user
  end

  factory :piece do
    x_position { 1 }
    y_position { 1 }

    association :game
  end

  factory :user do
    sequence(:email, 1000) { |n| "person#{n}@example.com" }
    password { 'password' }
  end
  
end

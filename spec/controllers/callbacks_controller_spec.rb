# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CallbacksController, type: :controller do
  before(:all) do
    OmniAuth.config.test_mode = true
  end

  after(:all) do
    OmniAuth.config.test_mode = false
  end

  context 'omniauth-facebook' do
    before(:each) do
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: '123545',
        info: { email: 'none@none.com' }
      )
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
      @user = User.from_omniauth(Rails.application.env_config['omniauth.auth'])
      sign_in @user
    end

    it 'checks if Omniauth-facebook is setting an email' do
      expect(@user.email).to eq(User.last.email)
    end
  end

  context 'omniauth-twitter' do
    before(:each) do
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
        provider: 'twitter',
        uid: '123545',
        info: { email: 'none@none.com' }
      )
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
      @user = User.from_omniauth(Rails.application.env_config['omniauth.auth'])
      sign_in @user
    end

    it 'checks if Omniauth-twitter is setting an email' do
      expect(@user.email).to eq(User.last.email)
    end
  end
end

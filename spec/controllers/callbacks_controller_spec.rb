# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CallbacksController, type: :controller do
  before(:all) do
    OmniAuth.config.test_mode = true
  end

  after(:all) do
    OmniAuth.config.test_mode = false
  end

  describe 'Omniauth' do
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

    it 'checks if Omniauth hash is setting an email with devise' do
      expect(@user.email).to eq(User.last.email)
    end
  end
end

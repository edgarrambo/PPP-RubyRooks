# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Factory bot test' do
  it 'ensures factoybot is working when mocking devise' do
    user = build(:user, email: 'john@smith.com')
    expect(user.email).to eq('john@smith.com')
  end
end

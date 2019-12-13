require 'rails_helper'

RSpec.describe 'Simple test' do
  it 'returns true always' do
    expect(true).to eq(true)
  end
end

RSpec.describe 'Factory bot test' do
  it 'ensures factoybot is working' do
    user = build(:user, email: 'john@smith.com')
    expect(user.email).to eq('john@smith.com')
  end
end
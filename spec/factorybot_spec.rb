# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Factory bot test' do
  it 'validates a factorybot user when mocking devise' do
    user = create(:user, email: 'john@smith.com', password: 'something', password_confirmation: 'something')
    expect(user).to be_valid
  end
end

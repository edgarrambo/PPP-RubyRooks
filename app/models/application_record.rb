# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def is_white?
    return piece_number < 6 
  end
end

class Movie < ApplicationRecord
  belongs_to :studio
  has_many :roles
  has_many :actors, through: :roles
end

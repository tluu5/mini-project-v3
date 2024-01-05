# Define a TvShow model
class TvShow < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title, :network, :release_date, :description
  validates_length_of :title, :network, :description, minimum: 3
end

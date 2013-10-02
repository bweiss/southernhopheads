# == Schema Information
#
# Table name: breweries
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  location    :string(255)
#  website     :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Brewery < ActiveRecord::Base
  attr_accessible :name, :description, :location, :website

  validates :name, :presence => true, :length => { :maximum => 120 }
  validates :description, :length => { :maximum => 2000 }
  validates :location, :length => { :maximum => 120 }
  validates :website, :length => { :maximum => 200 }

  has_many :beers, :dependent => :destroy
end

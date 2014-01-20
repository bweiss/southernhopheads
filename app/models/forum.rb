# == Schema Information
#
# Table name: forums
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string(255)
#  sort_value  :integer
#

class Forum < ActiveRecord::Base
  attr_accessible :name, :description, :sort_value

  validates :name,        :presence => true, :length => { :maximum => 100 }
  validates :description, :presence => true, :length => { :maximum => 300 }
  validates :sort_value,  :presence => true

  has_many :posts
end

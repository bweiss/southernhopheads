# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  score      :decimal(3, 1)
#  content    :text
#  beer_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Review < ActiveRecord::Base
  attr_accessible :content, :score

  validates :score, :presence => true, :inclusion => { :in => 0..10 }
  validates :content, :length => { :maximum => 2000 }

  belongs_to :beer
  belongs_to :user
end

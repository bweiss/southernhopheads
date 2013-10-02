# == Schema Information
#
# Table name: beers
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  brewery_id  :integer
#  abv         :decimal(5, 2)
#  srm         :integer
#  ibu         :integer
#  style       :string(255)
#  featured    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Beer < ActiveRecord::Base
  before_create :default_values

  attr_accessible :name, :description, :abv, :srm, :ibu, :style, :featured

  validates :name, :presence => true, :length => { :maximum => 120 }
  validates :description, :length => { :maximum => 2000 }
  validates :style, :length => { :maximum => 120 }

  belongs_to :brewery
  has_many :reviews, :dependent => :destroy

  scope :featured, where(:featured => true)

  private

    def default_values
      self.featured ||= false
      true
    end
end

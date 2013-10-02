# == Schema Information
#
# Table name: posts
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  content        :text
#  forum_id       :integer
#  user_id        :integer
#  sticky         :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  allow_comments :boolean          default(TRUE)
#

class Post < ActiveRecord::Base
  before_create :default_values
  
  attr_accessible :content, :title, :allow_comments

  validates :content, :presence => true, :length => { :maximum => 8000 }
  validates :title,   :presence => true, :length => { :maximum => 200 }

  belongs_to :forum
  belongs_to :user

  has_many :comments, :as => :commentable, :dependent => :destroy

  scope :stuck, where(:sticky => true)
  scope :unstuck, where(:sticky => false)

  private

    def default_values
      self.allow_comments ||= true
      self.sticky ||= false
      true
    end
end

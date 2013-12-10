# == Schema Information
#
# Table name: articles
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  content        :text
#  user_id        :integer
#  start_at       :datetime
#  end_at         :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  allow_comments :boolean
#  location       :string(255)
#  event          :boolean
#  published      :boolean          default(FALSE)
#

class Article < ActiveRecord::Base
  attr_accessible :content, :title, :allow_comments, :start_at, :end_at, :location, :event, :featured

  validates :title, :presence => true, :length => { :maximum => 100 }
  validates :content, :presence => true, :length => { :maximum => 3000 }

  has_event_calendar
  
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
 
  scope :published, where(:published => true)
  scope :notpublished, where(:published => false)
  scope :events, where(:event => true)
  scope :nonevents, where(:event => false)
  scope :featured, where(:featured => true)
  scope :notfeatured, where(:featured => false)

  def self.created_before(time)
    where("created_at < ?", time)
  end

  def self.created_after(time)
    where("created_at > ?", time)
  end

  def self.starts_before(time)
    where("start_at < ?", time)
  end

  def self.starts_after(time)
    where("start_at > ?", time)
  end
end

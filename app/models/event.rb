# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  content        :text
#  user_id        :integer
#  start_at       :datetime
#  end_at         :datetime
#  location       :string(255)
#  allow_comments :boolean          default(TRUE)
#  featured       :boolean          default(FALSE)
#  published      :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Event < ActiveRecord::Base
  attr_accessible :title, :content, :start_at, :end_at, :location, :allow_comments, :featured

  validates :title, :presence => true, :length => { :maximum => 100 }
  validates :content, :presence => true, :length => { :maximum => 3000 }

  has_event_calendar
  
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy

  scope :featured, where(:featured => true)
  scope :not_featured, where(:featured => false)
  scope :published, where(:published => true)
  scope :not_published, where(:published => false)

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

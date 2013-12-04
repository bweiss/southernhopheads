class Event < ActiveRecord::Base
  attr_accessible :content, :title, :allow_comments, :start_at, :end_at, :location, :event

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

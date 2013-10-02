# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  authentication_token   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#  location               :string(255)
#  whats_brewing          :text
#  email_visible          :boolean
#  favorite_beers         :text
#  email_new_events       :boolean
#  email_event_reminders  :boolean
#  email_new_comments     :boolean
#

class User < ActiveRecord::Base
  before_create :default_values
  before_save { self.email.downcase! }

  rolify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable,
         :trackable, :validatable, :token_authenticatable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :location,
                  :whats_brewing, :email_visible, :favorite_beers, :email_new_events,
                  :email_event_reminders, :email_new_comments

  has_many :comments, :dependent => :destroy
  has_many :articles, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :reviews, :dependent => :destroy

  VALID_NAME_REGEX = /[a-z\d\s]+/i
  validates :name, :presence => true,
                   :uniqueness => { :case_sensitive => false },
                   :format =>     { :with => VALID_NAME_REGEX },
                   :length =>     { :minimum => 2, :maximum => 16 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true,
                    :uniqueness => { :case_sensitive => false },
                    :format =>     { :with => VALID_EMAIL_REGEX },
                    :length =>     { :maximum => 128 }

  validates :location,       :length => { :maximum => 64 }
  validates :whats_brewing,  :length => { :maximum => 800 }
  validates :favorite_beers, :length => { :maximum => 800 }

  # Access token for a user
  def access_token
    User.create_access_token(self)
  end

  # Verifier based on our application secret
  def self.verifier
    ActiveSupport::MessageVerifier.new(Southernhopheads::Application.config.secret_token)
  end

  # Get a user from a token
  def self.read_access_token(signature)
    id = verifier.verify(signature)
    User.find_by_id id
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end

  # Class method for token generation
  def self.create_access_token(user)
    verifier.generate(user.id)
  end

  def self.find_users_to_email_new_events
    where('email_new_events = 1')
  end

  def self.find_users_to_email_event_reminders
    where('email_event_reminders = 1')
  end

  def self.find_users_to_email_new_comments
    where('email_new_comments = 1')
  end

  private

    def default_values
      self.email_visible ||= false
      self.email_new_events ||= true
      self.email_event_reminders ||= true
      self.email_new_comments ||= true
      self.add_role :user
    end
end

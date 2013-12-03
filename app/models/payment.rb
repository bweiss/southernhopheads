# == Schema Information
#
# Table name: payments
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  payment_type :string(255)      default("single"), not null
#  payment_date :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Payment < ActiveRecord::Base
  attr_accessible :payment_date, :payment_type, :as => :treasurer
  validates :payment_type, :presence => true
  validates :payment_date, :presence => true
  belongs_to :user
end

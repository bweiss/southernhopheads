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
#  featured       :boolean          default(FALSE)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    title "MyString"
    content "MyText"
    user_id 1
  end
end

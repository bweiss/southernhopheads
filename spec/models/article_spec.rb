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

require 'spec_helper'

describe Article do
  pending "add some examples to (or delete) #{__FILE__}"
end

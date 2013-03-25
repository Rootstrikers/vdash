# == Schema Information
#
# Table name: facebook_contents
#
#  id         :integer          not null, primary key
#  link_id    :integer
#  user_id    :integer
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FacebookContent < ActiveRecord::Base
  include ContentBase
  include Likable
  include Deletable

  def post!
    super
    # Actually post to Facebook
  end
end

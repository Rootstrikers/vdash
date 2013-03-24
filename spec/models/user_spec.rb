# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  admin      :boolean
#  uid        :string(255)
#  name       :string(255)
#  provider   :string(255)
#

require 'spec_helper'

describe User do
  it { should have_many :links }
  it { should have_many :likes }
  it { should have_many :posts }
  it { should have_many :twitter_contents }
  it { should have_many :facebook_contents }
  it { should have_many :notices }

  it 'is not an admin by default' do
    User.new.should_not be_admin
  end

  let(:user) { FactoryGirl.create(:user) }
  let(:link) { FactoryGirl.create(:link) }

  describe ".current" do
    it "returns the current user" do
      Thread.current[:current_user] = user
      User.current.should == user
    end
  end

  describe '#liked?(item)' do
    it 'returns false' do
      user.liked?(link).should be_false
    end

    it 'returns true if user has voted for the item' do
      user.likes << Like.new(item: link)
      user.liked?(link).should be_true
    end
  end
end

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
  it { should have_many :contents }
  it { should have_many :notices }
  it { should have_many :bans }

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

  describe '#banned?' do
    it 'returns false' do
      user.should_not be_banned
    end

    it 'returns false if user has a lifted ban' do
      FactoryGirl.create(:ban, user: user, lifted_at: 1.day.ago)
      user.should_not be_banned
    end

    it 'returns true if user has a current ban' do
      FactoryGirl.create(:ban, user: user, lifted_at: nil)
      user.should be_banned
    end
  end

  describe '#public_contact_information?' do
    it 'should be false by default' do
      User.new.public_contact_information?.should be_false
    end
  end
end

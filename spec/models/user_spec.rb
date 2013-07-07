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
  it { should have_many :clicks }
  it { should have_many :posts }
  it { should have_many :contents }
  it { should have_many :notices }
  it { should have_many :bans }

  it { should allow_value('').for(:google_url) }
  it { should allow_value('http://www.google.com/test').for(:google_url) }
  it { should_not allow_value('test').for(:google_url) }

  it { should allow_value('').for(:facebook_url) }
  it { should allow_value('http://www.facebook.com/test').for(:facebook_url) }
  it { should_not allow_value('test').for(:facebook_url) }

  it { should allow_value('').for(:twitter_url) }
  it { should allow_value('http://www.twitter.com/test').for(:twitter_url) }
  it { should_not allow_value('test').for(:twitter_url) }

  it { should allow_value('').for(:email) }
  it { should allow_value('test@example.com').for(:email) }
  it { should_not allow_value('test').for(:email) }

  it 'is not an admin by default' do
    User.new.should_not be_admin
  end

  let!(:user) { FactoryGirl.create(:user) }
  let!(:link) { FactoryGirl.create(:link) }

  describe ".current" do
    it "returns the current user" do
      Thread.current[:current_user] = user
      User.current.should == user
    end
  end

  describe '.existing_user(auth)' do
    let(:auth) { { 'provider' => 'facebook', 'uid' => '12345' } }

    it 'returns nil' do
      User.existing_user(auth).should be_nil
    end

    it 'returns an existing user with a matching linked account' do
      user = FactoryGirl.create(:user)
      user.linked_accounts.create(provider: 'facebook', uid: '12345')
      User.existing_user(auth).should == user
    end
  end

  describe '.create_from_omniauth(auth)' do
    let(:auth) do
      {
        'provider' => 'facebook',
        'uid'      => '12345',
        'info'     => {
          'name' => 'George'
        }
      }
    end

    it 'creates a user' do
      expect {
        User.create_from_omniauth(auth)
      }.to change(User, :count).by(1)
    end

    it 'creates a LinkedAccount' do
      expect {
        User.create_from_omniauth(auth)
      }.to change(LinkedAccount, :count).by(1)
    end

    it 'associates the linked account with the user' do
      User.create_from_omniauth(auth)
      LinkedAccount.last.user.should == User.last
    end

    it 'sets other attributes on the user' do
      User.create_from_omniauth(auth)
      User.last.name.should == 'George'
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

  describe '#clicked?(item)' do
    it 'returns false' do
      user.clicked?(link).should be_false
    end

    it 'returns true if user has voted for the item' do
      user.clicks << Click.new(item: link)
      user.clicked?(link).should be_true
    end

    it 'returns false for a content if link not clicked' do
      content = FactoryGirl.create(:content)
      user.clicked?(content).should be_false
    end

    it 'returns true for a content if link was clicked' do
      content = FactoryGirl.create(:content, link: link)
      user.clicks << Click.new(item: link)
      user.clicked?(content).should be_true
    end
  end

  describe '#able_to_like?(item)' do
    it 'returns false' do
      user.should_not be_able_to_like(link)
    end

    it 'returns true if user clicked item' do
      user.stub(clicked?: true)
      user.should be_able_to_like(link)
    end

    it 'returns true if user owns link' do
      link = FactoryGirl.create(:link, user: user)
      user.stub(clicked?: false)
      user.should be_able_to_like(link)
    end

    it 'can return false for a content' do
      content = FactoryGirl.create(:content)
      user.should_not be_able_to_like(content)
    end

    it 'returns true if the user owns the content' do
      content = FactoryGirl.create(:content, user: user)
      user.should be_able_to_like content
    end

    it 'returns true if user owns associated link' do
      link = FactoryGirl.create(:link, user: user)
      content = FactoryGirl.create(:content, link: link)
      user.should be_able_to_like content
    end
  end

  describe '#toggle_like(item)' do
    context 'when the user has not liked the item' do
      it 'creates a like' do
        expect {
          user.toggle_like(link)
        }.to change(Like, :count).by(1)
      end

      it 'associates the like with the user' do
        user.toggle_like(link)
        Like.last.user.should == user
      end

      it 'associates the like with the item' do
        user.toggle_like(link)
        Like.last.item.should == link
      end
    end

    context 'when the user has already liked the item' do
      before { FactoryGirl.create(:like, item: link, user: user) }

      it 'destroys the like' do
        expect {
          user.toggle_like(link)
        }.to change(Like, :count).by(-1)
      end
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

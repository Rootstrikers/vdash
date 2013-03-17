# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string(255)
#  summary    :text
#

require 'spec_helper'

describe Link do
  it_behaves_like 'it is likable'

  it { should belong_to :user }
  it { should have_many :twitter_contents }
  it { should have_many :facebook_contents }

  it { should validate_presence_of :url }
  it { should validate_uniqueness_of :url }

  let(:link) { FactoryGirl.create(:link) }

  describe '#error_due_to_duplicate_url?' do
    it 'returns false typically' do
      link.error_due_to_duplicate_url?.should be_false
    end

    it 'returns true if attempting to create a new link with the same url as one that already exists' do
      new_link = Link.new(url: link.url)
      new_link.valid?
      new_link.error_due_to_duplicate_url?.should be_true
    end
  end

  describe '#link_with_same_url' do
    it 'returns nil typically' do
      link.link_with_same_url.should be_nil
    end

    it 'returns the link that already exists with the same url if present' do
      new_link = Link.new(url: link.url)
      new_link.link_with_same_url.should == link
    end
  end

  describe '#display_name' do
    it 'returns the title when present' do
      link = FactoryGirl.create(:link, title: 'This is the title')
      link.display_name.should == 'This is the title'
    end

    it 'returns the URL otherwise' do
      link = FactoryGirl.create(:link, title: nil)
      link.display_name.should == link.url
    end
  end

  describe '#liked_by?(user)' do
    let(:user) { FactoryGirl.create(:user) }

    it 'returns false if link was not liked by user' do
      link.should_not be_liked_by(user)
    end

    it 'returns true if link was liked by user' do
      FactoryGirl.create(:like, item: link, user: user)
      link.should be_liked_by(user)
    end
  end
end

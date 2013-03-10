require 'spec_helper'

describe Link do
  it { should belong_to :user }
  it { should have_many :likes }
  it { should have_one :twitter_content }
  it { should have_one :facebook_content }

  it { should validate_presence_of :url }
  it { should validate_uniqueness_of :url }

  describe '#error_due_to_duplicate_url?' do
    it 'returns false typically' do
      link = FactoryGirl.create(:link)
      link.error_due_to_duplicate_url?.should be_false
    end

    it 'returns true if attempting to create a new link with the same url as one that already exists' do
      link = FactoryGirl.create(:link)
      new_link = Link.new(url: link.url)
      new_link.valid?
      new_link.error_due_to_duplicate_url?.should be_true
    end
  end

  describe '#link_with_same_url' do
    it 'returns nil typically' do
      link = FactoryGirl.create(:link)
      link.link_with_same_url.should be_nil
    end

    it 'returns the link that already exists with the same url if present' do
      link = FactoryGirl.create(:link)
      new_link = Link.new(url: link.url)
      new_link.link_with_same_url.should == link
    end
  end
end

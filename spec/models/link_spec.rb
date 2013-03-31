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
  it_behaves_like 'it is deletable'

  it { should belong_to :user }
  it { should have_many :twitter_contents }
  it { should have_many :facebook_contents }

  it { should validate_uniqueness_of :url }

  let(:link) { FactoryGirl.create(:link) }

  it 'requires a url' do
    link = Link.new(url: '')
    link.valid?.should == false
    link.errors[:url].should == ["can't be blank"]
  end

  describe '.unposted' do
    before { link }

    it 'includes links with no posts' do
      Link.unposted.should == [link]
    end

    it 'includes links only posted to twitter' do
      content = FactoryGirl.create(:twitter_content, link: link)
      FactoryGirl.create(:post, content: content)
      Link.unposted.should == [link]
    end

    it 'includes links only posted to facebook' do
      content = FactoryGirl.create(:facebook_content, link: link)
      FactoryGirl.create(:post, content: content)
      Link.unposted.should == [link]
    end

    it 'does not include links posted to twitter and facebook' do
      twitter_content = FactoryGirl.create(:twitter_content, link: link)
      FactoryGirl.create(:post, content: twitter_content)
      facebook_content = FactoryGirl.create(:facebook_content, link: link)
      FactoryGirl.create(:post, content: facebook_content)
      Link.unposted.should == []
    end
  end

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

  describe '#url_without_protocol' do
    it 'initializes a new DomainName and only calls strip_protocol on it' do
      domain_name = mock
      domain_name.should_receive(:strip_protocol).and_return('www.example.com')
      Link::DomainName.should_receive(:new).with(link.url).and_return(domain_name)

      link.url_without_protocol.should == 'www.example.com'
    end
  end

  describe '#display_name' do
    it 'returns the title when present' do
      link = FactoryGirl.create(:link, title: 'This is the title')
      link.display_name.should == 'This is the title'
    end

    it 'returns the URL when the title is an empty string' do
      link = FactoryGirl.create(:link, title: '')
      link.display_name.should == link.url_without_protocol
    end

    it 'returns the URL when the title is nil' do
      link = FactoryGirl.create(:link, title: nil)
      link.display_name.should == link.url_without_protocol
    end

    it "doesn't include the protocol if displaying the url" do
      link = FactoryGirl.create(:link, title: '', url: 'http://foo.com/bar?baz=1#shoo')
      link.display_name.should == 'foo.com/bar?baz=1#shoo'
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

  describe '#domain' do
    it 'strips out the protocol' do
      link.url = 'http://example.com'
      link.domain.should == 'example.com'
    end

    it 'strips out www' do
      link.url = 'http://www.example.com'
      link.domain.should == 'example.com'
    end

    it 'strips out the path if it starts with a slash' do
      link.url = 'http://www.example.com/stuff'
      link.domain.should == 'example.com'
    end

    it 'strips out parameters' do
      link.url = 'http://www.example.com?stuff=things'
      link.domain.should == 'example.com'
    end

    it 'returns the plain url if already only the domain' do
      link.url = 'example.com'
      link.domain.should == 'example.com'
    end
  end

  describe '#url=(new_url)' do
    it 'prepends http:// if protocol is missing' do
      link.url = 'cnn.com'
      link.url.should == 'http://cnn.com'
    end

    it 'prepends http:// if protocol is missing in mass assignment' do
      link.update_attributes(url: 'cnn.com')
      link.url.should == 'http://cnn.com'
    end

    it "doesn't prepend protocol if http given" do
      link.url = 'http://cnn.com'
      link.url.should == 'http://cnn.com'
    end

    it "doesn't prepend protocol if https given" do
      link.url = 'https://cnn.com'
      link.url.should == 'https://cnn.com'
    end
  end
end

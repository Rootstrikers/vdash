# == Schema Information
#
# Table name: contents
#
#  id         :integer          not null, primary key
#  link_id    :integer
#  user_id    :integer
#  body       :text
#  like_count :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Content do
  it_behaves_like 'it is likable'
  it_behaves_like 'it is deletable'

  it { should belong_to :link }
  it { should belong_to :user }
  it { should have_many :posts }

  subject { FactoryGirl.create(:content) }
  it { should validate_presence_of :body }

  let(:user) { FactoryGirl.create(:user) }
  let(:content) { FactoryGirl.create(:content) }
  before { Thread.current[:current_user] = user }

  describe 'content creation validations based on if link will accept a new content from user' do
    let!(:content) { FactoryGirl.build(:content, user: user) }

    context 'when the link says the user can add content' do
      before { content.link.stub(:can_add_content?).with(user).and_return(true) }

      it 'validates if link says user can add content' do
        content.should be_valid
      end
    end

    context 'when the link says the user cannot add content' do
      before { content.link.stub(:can_add_content?).with(user).and_return(false) }

      it 'is invalid' do
        content.should_not be_valid
      end

      it 'adds an error to :base' do
        content.valid?
        content.errors[:base].first.should == "A link can only have #{Link::MAX_CONTENTS} post suggestions, and only #{Link::MAX_CONTENTS_PER_USER} per user."
      end
    end
  end

  describe '.unposted' do
    it 'only returns unposted content' do
      posted_content = FactoryGirl.create(:posted_content)
      unposted_content = FactoryGirl.create(:content)

      described_class.unposted.should == [unposted_content]
    end
  end

  describe '.posted' do
    it 'only returns posted content' do
      posted_content = FactoryGirl.create(:posted_content)
      unposted_content = FactoryGirl.create(:content)

      described_class.posted.should == [posted_content]
    end
  end

  describe '.posted_to_twitter' do
    it 'only returns content posted to twitter' do
      twitter_content = FactoryGirl.create(:posted_twitter_content)
      facebook_content = FactoryGirl.create(:posted_facebook_content)
      unposted_content = FactoryGirl.create(:content)

      described_class.posted_to_twitter.should == [twitter_content]
    end
  end

    describe '.posted_to_facebook' do
    it 'only returns content posted to facebook' do
      twitter_content = FactoryGirl.create(:posted_twitter_content)
      facebook_content = FactoryGirl.create(:posted_facebook_content)
      unposted_content = FactoryGirl.create(:content)

      described_class.posted_to_facebook.should == [facebook_content]
    end
  end

  describe '.newest_post_first' do
    it 'returns content in order they were posted (most recent first)' do
      content_one = FactoryGirl.create(:content)
      content_two = FactoryGirl.create(:content)

      FactoryGirl.create(:post, content: content_two)
      FactoryGirl.create(:post, content: content_one)

      described_class.posted.should == [content_two, content_one]
    end
  end

  describe '#post!' do
    it 'creates a Post' do
      expect {
        content.post!(service: :facebook)
      }.to change(Post, :count).by(1)
    end

    it 'associates the post with the content' do
      content.post!(service: :facebook)
      Post.last.content.should == content
    end

    it 'associates the post with the current user' do
      content.post!(service: :facebook)
      Post.last.user.should == user
    end

    it 'sets the type' do
      content.post!(service: :twitter)
      Post.last.type.should == 'Posts::Twitter'
    end
  end

  describe '#valid_for_twitter?' do
    it 'returns true if body is less than 120 characters long' do
      Content.new(body: 'This is a short string.').should be_valid_for_twitter
    end

    it 'returns true if body is 120 characters long' do
      Content.new(body: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa').should be_valid_for_twitter
    end

    it 'returns false if body is greater than 120 characters long' do
      Content.new(body: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.').should_not be_valid_for_twitter

    end
  end
end

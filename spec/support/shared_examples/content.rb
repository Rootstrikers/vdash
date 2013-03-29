shared_examples "content" do
  it { should belong_to :link }
  it { should belong_to :user }
  it { should have_many :posts }

  it { should validate_presence_of :body }

  let(:user) { FactoryGirl.create(:user) }
  let(:content) { instance_of_described_class }
  before { Thread.current[:current_user] = user }

  describe '.unposted' do
    it 'only returns unposted content' do
      posted_content = instance_of_described_class
      FactoryGirl.create(:post, content: posted_content)
      unposted_content = instance_of_described_class

      described_class.unposted.should == [unposted_content]
    end
  end

  describe '.posted' do
    it 'only returns posted content' do
      posted_content = instance_of_described_class
      FactoryGirl.create(:post, content: posted_content)
      unposted_content = instance_of_described_class

      described_class.posted.should == [posted_content]
    end
  end

  describe '.newest_post_first' do
    it 'returns content in order they were posted (most recent first)' do
      content_one = instance_of_described_class
      content_two = instance_of_described_class

      FactoryGirl.create(:post, content: content_two)
      FactoryGirl.create(:post, content: content_one)

      described_class.posted.should == [content_two, content_one]
    end
  end

  describe '#post!' do
    it 'creates a Post' do
      expect {
        content.post!
      }.to change(Post, :count).by(1)
    end

    it 'associates the post with the content' do
      content.post!
      Post.last.content.should == content
    end

    it 'associates the post with the current user' do
      content.post!
      Post.last.user.should == user
    end
  end
end
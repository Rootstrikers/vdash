shared_examples "content" do
  it { should belong_to :link }
  it { should belong_to :user }
  it { should have_many :posts }

  it { should validate_presence_of :body }

  let(:user) { FactoryGirl.create(:user) }
  let(:content) { instance_of_described_class }
  before { Thread.current[:current_user] = user }

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
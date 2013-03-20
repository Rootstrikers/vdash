shared_examples "it is likable" do
  it { should have_many :likes }
  it { should have_many(:liked_by_users).through(:likes) }

  it 'sets like_count' do
    thing = FactoryGirl.create(described_class.name.underscore.to_sym)
    3.times { thing.likes << Like.new }
    thing.reload.like_count.should == 3
  end
end
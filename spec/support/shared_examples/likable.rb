shared_examples "it is likable" do
  it { should have_many :likes }
  it { should have_many(:liked_by_users).through(:likes) }

  it 'creates a like automatically' do
    thing = instance_of_described_class
    thing.likes.count.should == 1
  end

  it 'creates a like for the person who created the thing' do
    thing = instance_of_described_class
    thing.likes.first.user.should == thing.user
  end

  it 'sets like_count' do
    thing = instance_of_described_class
    3.times { thing.likes << Like.new }
    thing.reload.like_count.should == 4
  end

  describe '.ordered' do
    it 'orders by like_count' do
      thing_1 = instance_of_described_class
      thing_2 = instance_of_described_class
      thing_3 = instance_of_described_class

      thing_1.update_attribute(:like_count, 5)
      thing_2.update_attribute(:like_count, 2)
      thing_3.update_attribute(:like_count, 4)

      described_class.ordered.should == [thing_1, thing_3, thing_2]
    end
  end
end
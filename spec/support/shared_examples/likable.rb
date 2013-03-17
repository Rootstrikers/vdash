shared_examples "it is likable" do
  it { should have_many :likes }
  it { should have_many(:liked_by_users).through(:likes) }
end
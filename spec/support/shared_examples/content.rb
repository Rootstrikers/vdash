shared_examples "content" do
  it { should belong_to :link }
  it { should belong_to :user }
  it { should have_many :posts }
end
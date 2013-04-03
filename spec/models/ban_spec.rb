require 'spec_helper'

describe Ban do
  it { should belong_to :user }
  it { should belong_to :created_by }

  describe '.unlifted' do
    it 'returns unlifted bans' do
      lifted = FactoryGirl.create(:ban, lifted_at: Time.now)
      unlifted = FactoryGirl.create(:ban, lifted_at: nil)

      Ban.unlifted.should == [unlifted]
    end
  end

  describe '.newest_first' do
    it 'returns the newest posts first' do
      ban_one = FactoryGirl.create(:ban, created_at: 2.days.ago)
      ban_two = FactoryGirl.create(:ban, created_at: 1.day.ago)

      Ban.newest_first.should == [ban_two, ban_one]
    end
  end

end

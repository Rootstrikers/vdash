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

end

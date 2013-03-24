require 'spec_helper'

describe Notice do
  it { should validate_presence_of :body }
  it { should belong_to :user }

  it 'should be active by default' do
    Notice.new.should be_active
  end

  it 'inactivates other notice when a new active notice is created' do
    original_active_notice = FactoryGirl.create(:notice, active: true)
    new_active_notice      = FactoryGirl.create(:notice, active: true)

    original_active_notice.reload.should_not be_active
    new_active_notice.reload.should be_active
  end

  describe '.active' do
    it 'returns the first active notice' do
      active = FactoryGirl.create(:notice, :active => true)
      inactive = FactoryGirl.create(:notice, :active => false)

      Notice.active.should == active
    end

    it 'returns nil if no active notice' do
      Notice.active.should be_nil
    end
  end
end

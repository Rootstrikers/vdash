require 'spec_helper'

describe ApplicationHelper do
  describe '#like_action_class(user, item)' do
    it 'always returns like-action' do
      helper.like_action_class(stub(liked?: false), stub).should == 'like-action'
    end

    it 'returns "like-action voted" when user has voted on item' do
      helper.like_action_class(stub(liked?: true), stub).should == 'like-action voted'
    end
  end
end

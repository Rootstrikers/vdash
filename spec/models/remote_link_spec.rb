require 'spec_helper'

describe RemoteLink do
  let(:remote_link) { RemoteLink.new(File.join(Rails.root, "spec/fixtures/remote_link.html")) }

  describe '#title' do
    it 'returns the title of the web page' do
      remote_link.title.should == 'This is my title'
    end
  end

  describe '#first_paragraph' do
    it 'returns the first paragraph of the web page' do
      remote_link.first_paragraph.should == 'This is my paragraph.'
    end
  end
end

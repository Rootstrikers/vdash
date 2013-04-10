require 'spec_helper'

describe Url do
  describe '#initialize' do
    let(:url) { Url.new('http://www.example.com') }

    it 'sets the url attribute' do
      url.url.should == 'http://www.example.com'
    end

    it 'sets the raw_url attribute' do
      url.raw_url.should == 'http://www.example.com'
    end
  end

  describe '#to_s' do
    context 'when given a valid url' do
      it 'just returns the url' do
        Url.new('http://www.example.com').to_s.should == 'http://www.example.com'
      end

      it 'defaults to http if no scheme given' do
        Url.new('www.example.com').to_s.should == 'http://www.example.com'
      end
    end
  end
end

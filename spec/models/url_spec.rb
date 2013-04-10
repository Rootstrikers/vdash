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
    it 'just returns the url when given a complete url' do
      Url.new('http://www.example.com').to_s.should == 'http://www.example.com'
    end

    it 'defaults to http if no scheme given' do
      Url.new('www.example.com').to_s.should == 'http://www.example.com'
    end

    it 'returns nil if given nil' do
      Url.new(nil).to_s.should be_nil
    end

    it 'returns "" if given ""' do
      Url.new('').should == ''
    end
  end

  describe '#valid?' do
    it 'returns true for complete http urls' do
      Url.new('http://www.example.com').should be_valid
    end

    it 'returns true for complete https urls' do
      Url.new('https://www.example.com').should be_valid
    end

    it 'returns true if we give it a valid url without protocol due to defaulting to http' do
      Url.new('www.example.com').should be_valid
    end

    it 'returns false if we give it /etc/passwd' do
      Url.new('/etc/passwd').should_not be_valid
    end

    it 'returns false if we give it a single word' do
      Url.new('apples').should_not be_valid
    end

    it 'returns false for nil' do
      Url.new(nil).should_not be_valid
    end

    it 'returns false for an empty string' do
      Url.new('').should_not be_valid
    end
  end
end

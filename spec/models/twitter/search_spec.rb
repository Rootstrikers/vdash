require 'spec_helper'

module Twitter
  describe Search do
    let(:search) { described_class.new(File.join(Rails.root, "spec/fixtures/twitter_search.json")) }

    describe '#new' do
      it 'it sets the url' do
        search.url.should == File.join(Rails.root, "spec/fixtures/twitter_search.json")
      end
    end

    describe '#fetch' do
      context 'parsed json' do
        before { search.fetch }

        it 'has a results array' do
          search.contents['results'].should be_an Array
        end

        it 'has fifteen results' do
          search.contents['results'].size.should == 15
        end

        context 'an example result' do
          subject { search.contents['results'].first }
          its(['created_at']) { should == 'Tue, 30 Apr 2013 00:40:54 +0000'}
          its(['from_user'])  { should == 'Danareed45452' }
          its(['from_user_id']) { should == 1255176156 }
          its(['from_user_id_str']) { should == '1255176156' }
          its(['from_user_name']) { should == 'Dana Reed' }
          its(['geo']) { should be_nil }
          its(['id']) { should == 329032577459556354 }
          its(['iso_language_code']) { should == 'en' }
          its(['metadata']) { should == { 'result_type' => 'recent' } }
          its(['profile_image_url']) { should == 'http://a0.twimg.com/profile_images/3358882778/ebd93df0f4143ad2619eda137b4da1f4_normal.jpeg' }
          its(['profile_image_url_https']) { should == 'https://si0.twimg.com/profile_images/3358882778/ebd93df0f4143ad2619eda137b4da1f4_normal.jpeg' }
          its(['source']) { should == '&lt;a href=&quot;http://twitter.com/&quot;&gt;web&lt;/a&gt;' }
          its(['text']) { should == 'RT @lessig: Cenk at #Rootstrikers Conference:  http://t.co/G01cXdUnPJ via @youtube' }
        end
      end
    end
  end
end

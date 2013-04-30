require 'spec_helper'

module Twitter
  describe Result do
    RESULT_JSON = JSON.parse('{
      "created_at": "Mon, 29 Apr 2013 19:24:37 +0000",
      "from_user": "TrepLaw",
      "from_user_id": 202616721,
      "from_user_id_str": "202616721",
      "from_user_name": "Entrepreneurial Law ",
      "geo": null,
      "id": 328952984803368960,
      "id_str": "328952984803368960",
      "iso_language_code": "en",
      "metadata": {
        "result_type": "recent"
      },
      "profile_image_url": "http://a0.twimg.com/profile_images/2874735532/67d73abad0e8d03e4f0a413e2db5dfc3_normal.jpeg",
      "profile_image_url_https": "https://si0.twimg.com/profile_images/2874735532/67d73abad0e8d03e4f0a413e2db5dfc3_normal.jpeg",
      "source": "&lt;a href=&quot;http://dlvr.it&quot;&gt;dlvr.it&lt;/a&gt;",
      "text": "The Need For Transparency in Political Donations http://t.co/vbsP4CpTFu #rootstrikers"
    }')

    describe '.from_json' do
      context 'when a Result with a matching tweet_id already exists' do
        before { FactoryGirl.create(:twitter_result, tweet_id: '328952984803368960') }

        it 'does not create a Result' do
          expect {
            described_class.from_json(RESULT_JSON)
          }.not_to change(Result, :count)
        end
      end

      context 'when a Result with a matching tweet_id does not exist' do
        it 'creates a Result' do
          expect {
            described_class.from_json(RESULT_JSON)
          }.to change(Result, :count).by(1)
        end

        subject { described_class.from_json(RESULT_JSON).reload }

        its(:tweet_created_at) { should == 'Mon, 29 Apr 2013 19:24:37 +0000' }
        its(:tweet_from_user_id) { should == '202616721' }
        its(:tweet_from_user) { should == 'TrepLaw' }
        its(:tweet_from_user_name) { should == 'Entrepreneurial Law ' }
        its(:tweet_geo) { should be_nil }
        its(:tweet_id) { should == '328952984803368960' }
        its(:tweet_iso_language_code) { should == 'en' }
        its(:tweet_profile_image_url) { should == 'http://a0.twimg.com/profile_images/2874735532/67d73abad0e8d03e4f0a413e2db5dfc3_normal.jpeg' }
        its(:tweet_source) { should == '&lt;a href=&quot;http://dlvr.it&quot;&gt;dlvr.it&lt;/a&gt;' }
        its(:tweet_text) { should == 'The Need For Transparency in Political Donations http://t.co/vbsP4CpTFu #rootstrikers' }
      end
    end
  end
end

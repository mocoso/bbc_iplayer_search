require 'spec_helper'

describe 'A category request' do
  context 'for a category with programmes in it', :vcr do
    subject { BBCIplayerSearch::Category.new('films') }

    it { expect(subject.programmes).to_not be_empty }
    it { expect(subject.programmes.first[:title]).to_not be_empty }
    it { expect(subject.programmes.first[:url]).to match(%r{^http://www.bbc.co.uk/iplayer/episode/.*}) }
    it { expect(subject.programmes.first[:image_url]).to match(%r{http://ichef.bbci.co.uk/images/ic/.*\.jpg}) }
  end

  context 'with unrecognised page format returned' do
    before do
      VCR.turn_off!

      stub_request(:get, 'http://www.bbc.co.uk/iplayer/categories/films/all?sort=dateavailable').
        to_return(:body => '<html><body><h1>Not what you expected</h1></body></html>')
    end

    after do
      VCR.turn_on!
    end

    it do
      expect {
        BBCIplayerSearch::Category.new('films').programmes
      }.to raise_error(BBCIplayerSearch::PageNotRecognised)
    end
  end
end


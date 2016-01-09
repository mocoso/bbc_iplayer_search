require 'spec_helper'

describe 'A search' do
  context 'with zero results', :vcr do
    it { expect(BBCIplayerSearch::Search.new.search('qqqqqqqqqqqqqqqqq')).to be_empty }
  end

  context 'with some results', :vcr do
    subject { BBCIplayerSearch::Search.new.search('eastenders') }

    it { expect(subject).to_not be_empty }
    it { expect(subject.first[:title]).to eq('EastEnders') }
    it { expect(subject.first[:url]).to match(%r{^http://www.bbc.co.uk/iplayer/episode/.*}) }
    it { expect(subject.first[:image_url]).to match(%r{http://ichef.bbci.co.uk/images/ic/.*\.jpg}) }
  end

  context 'with unrecognised page format returned' do
    before do
      VCR.turn_off!

      stub_request(:get, 'http://www.bbc.co.uk/iplayer/search?q=eastenders').
        to_return(:body => '<html><body><h1>Not what you expected</h1></body></html>')
    end

    after do
      VCR.turn_on!
    end

    it do
      expect {
        BBCIplayerSearch::Search.new.search('eastenders') 
      }.to raise_error(BBCIplayerSearch::PageNotRecognised)
    end
  end
end

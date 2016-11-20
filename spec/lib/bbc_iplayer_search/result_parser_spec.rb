require 'spec_helper'

describe BBCIplayerSearch::ResultParser do
  let(:title) { 'Citizen Kane' }
  let(:path) { '/iplayer/episode/b0074n82/citizen-kane' }
  let(:image_url) { 'http://ichef.bbci.co.uk/images/ic/336x189/p01gct3l.jpg' }
  let(:fragment) {
    Nokogiri::HTML::DocumentFragment.parse("<li class='list-item'>
      <a href='/iplayer/episode/b0074n82/citizen-kane'>
        <div class='title'>Citizen Kane</div>
        <div>
          <div>
            <picture>
              <source srcset='#{image_url}' />
            </picture>
          </div>
        </div>
      </a>
    </li>")
  }

  subject { BBCIplayerSearch::ResultParser.new(fragment) }

  describe '#title' do
    it { expect(subject.title).to eq(title) }
  end

  describe '#url' do
    it { expect(subject.url).to eq('http://www.bbc.co.uk/iplayer/episode/b0074n82/citizen-kane') }
  end

  describe '#image_url' do
    it { expect(subject.image_url).to eq(image_url) }
  end

  describe '#available' do
    it { expect(subject.available?).to eq(true) }

    context 'when not available' do
      let(:fragment) {
        Nokogiri::HTML::DocumentFragment.parse("<li class='list-item unavailable'>
        </li>")
      }

      it { expect(subject.available?).to eq(false) }
    end
  end
end

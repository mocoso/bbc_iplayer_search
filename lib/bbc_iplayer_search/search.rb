require 'uri'
require 'nokogiri'
require 'httpclient'

module BBCIplayerSearch
  class Search
    def search(query)
      r = response(query)
      programmes = programme_fragments(r.body).map do |f|
        rp = ResultParser.new(f)
        {
          :title => rp.title,
          :url => rp.url,
          :image_url => rp.image_url,
          :available => rp.available?
        }
      end

      if programmes.empty? & !no_results_page?(r.body)
        raise BBCIplayerSearch::PageNotRecognised
      else
        programmes
      end
    end

    private
    def no_results_page?(page)
      page.include?('There are no results for')
    end

    def response(query)
      HTTPClient.new.get('http://www.bbc.co.uk/iplayer/search', { 'q' => query })
    end

    def programme_fragments(page)
      Nokogiri::HTML(page).css('.iplayer-list li.list-item')
    end
  end
end

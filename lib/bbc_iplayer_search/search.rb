require 'uri'
require 'nokogiri'
require 'httpclient'

module BBCIplayerSearch
  class Search
    def search(query)
      r = response(query)
      programmes = programme_fragments(r.body).map { |f|
        {
          :title => programme_title(f),
          :url => programme_url(f),
          :image_url => programme_image_url(f)
        }
      }

      if programmes.empty? & !no_results_page?(r.body)
        raise BBCIplayerSearch::SearchResultsPageNotRecognised
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

    def programme_title(fragment)
      fragment.css('.title').first.content.strip
    end

    def programme_url(fragment)
      u = URI.parse(extract_rental_path_or_url(fragment))
      u.host ||= 'www.bbc.co.uk'
      u.scheme ||= 'http'
      u.to_s
    end

    def extract_rental_path_or_url(fragment)
      fragment.css('a').first.attributes['href'].value
    end

    def programme_image_url(fragment)
      fragment.css('.r-image').first.attributes['data-ip-src'].value
    end
  end
end

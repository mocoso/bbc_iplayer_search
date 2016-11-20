module BBCIplayerSearch
  class ResultParser
    def initialize(fragment)
      @fragment = fragment
    end

    def title
      fragment.css('.title').first.content.strip
    end

    def url
      u = URI.parse(extract_path_or_url)
      u.host ||= 'www.bbc.co.uk'
      u.scheme ||= 'http'
      u.to_s
    end

    def image_url
      fragment.css('source').first.attributes['srcset'].value
    end

    def available?
      fragment.css('.unavailable').empty?
    end

    private
    attr_reader :fragment

    def extract_path_or_url
      fragment.css('a').first.attributes['href'].value
    end
  end
end


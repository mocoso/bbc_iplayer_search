module BBCIplayerSearch
  class Category
    def initialize(slug)
      @slug = slug
    end

    def programmes
      r = response
      programmes = programme_fragments(r.body).map do |f|
        rp = ResultParser.new(f)
        {
          :title => rp.title,
          :url => rp.url,
          :image_url => rp.image_url,
          :available => rp.available?
        }
      end

      if programmes.empty?
        raise BBCIplayerSearch::PageNotRecognised
      else
        programmes
      end
    end

    private
    attr_reader :slug

    def response
      HTTPClient.new.get("http://www.bbc.co.uk/iplayer/categories/#{slug}/all", { 'sort' => 'dateavailable' })
    end

    def programme_fragments(page)
      Nokogiri::HTML(page).css('.iplayer-list li.list-item')
    end
  end
end

bbc\_iplayer\_search is a Ruby gem which provides a page scraped API for
searching the programmes available for streaming from the BBC iPlayer

# Installation

    $ gem install bbc_iplayer_search

Or with Bundler in your Gemfile.

    gem 'bbc_iplayer_search'

# Usage

    require 'bbc_iplayer_search'

    iplayer_search = BBCIplayerSearch::Search.new
    
    results = iplayer_search.search('eastenders')
    
Where the results are an array containing a hash for each result. Each
result has `title`, `url` and `image_url` keys.

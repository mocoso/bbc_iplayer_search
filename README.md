bbc\_iplayer\_search is a Ruby gem which provides a page scraped API for
searching the programmes available for streaming from the BBC iPlayer

# Installation

    $ gem install bbc_iplayer_search

Or with Bundler in your Gemfile.

    gem 'bbc_iplayer_search'

# Usage

## Search

    require 'bbc_iplayer_search'

    iplayer_search = BBCIplayerSearch::Search.new
    
    results = iplayer_search.search('eastenders')
    
Where the results are an array containing a hash for each result. Each
result has `title`, `url`, `image_url` and 'available' keys.

## Category listings

    require 'bbc_iplayer_search'

    programmes = BBCIplayerSearch::Category.new('films')
    
Where you pass in the slug of the category i.e. 'films' or 'drama-and-soaps'
and the `programmes` returned are an array ordered by how recently they
became available containing a hash for each result. Each result has `title`,
`url`, `image_url` and 'available' keys.

Note: both are the search and category calls are currently restricted to the
first page of results.

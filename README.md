# WebFixtures

WebFixtures lets you easily generate fixture files for web service response.

    # my_fixtures.rb
    
    require 'rubygems'
    require 'web_fixtures'
    
    WebFixtures.generate do
      
      storage_path "spec/fixtures"
      include_headers true
      authenticate false
      
      get "http://www.google.com"
      
    end

Also comes with a command line tool `web_fixtures` which allow you to run simple DSL-only files:

    # my_fixtures.txt
    
    include_headers true
    authenticate true
    
    get "http://api.foursquare.com/v1/user"
    get "http://www.foursquare.com", :authenticate => false
    post "http://api.foursquare.com/v1/checkin", :data => { :vid => 24676 }

## File Storage

The generated files are stored to the storage_path in subfolders according to the requested domain name.  The filename is build according to the path-part of the URI. e.g., the result of a request to "http://www.google.com/images/" will be stored in `./fixtures/www.google.com/images.txt`.

## Authentication

WebFixtures supports authentication through Basic HTTP Auth.  After setting `authenticate true`, WebFixtures will ask for your username and password:

    $ web_fixtures /path/to/dsl.file
    Username: my@email.com
    Password: 
    $

## DSL Options

* Supports `get`, `post`, `put` and `delete` requests
* Can enable/disable storing header data with `include_headers` [default: true]
* Specify storage path for fixtures with `storage_path` [default: './fixtures']
* Supports HTTP Basic Auth with the `authenticate` option [default: false]
* Pass data to a URI via the `:data` inline option [default: nil]
* These options are available as both top-level methods and inline options for overriding defaults on a single request.

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Jeff Tucker. See LICENSE for details.

# -*- encoding: utf-8 -*-

require 'digest/sha1'
require 'open-uri'
require 'nokogiri'

def main
  url = 'http://www.leafkyoto.net/event/detail/496'
  content = load_web_content(url)
  content.size # => 116725
end

def load_web_content(url)
  fname = 'cache/' + Digest::SHA256.hexdigest(url)
  if File.exist?(fname)
    content = File.read(fname)
    content.size # => 116725
    content
  else
    open(url) {|f|
      content = f.read
      open(fname, 'w') {|out|
        out.write content
      }
      content.size # =>
      content
    }
  end
end

case $PROGRAM_NAME
when __FILE__
  main
when /spec[^\/]*$/
  # {spec of the implementation}
end


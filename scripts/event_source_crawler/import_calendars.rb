# -*- encoding: utf-8 -*-

FileUtils.cd(File.dirname(__FILE__))
require './../../config/environment'

def main
  crawler = ::Bussan10EventSourceCrawler.new
  crawler.crawl
  crawler = ::DigistyleEventSourceCrawler.new
  crawler.crawl
  crawler = ::LeafEventSourceCrawler.new
  crawler.crawl
  crawler = ::WalkerplusEventSourceCrawler.new
  crawler.crawl
end

case $PROGRAM_NAME
when __FILE__
  main
when /spec[^\/]*$/
end


# -*- encoding: utf-8 -*-

FileUtils.cd(File.dirname(__FILE__))
require './../../config/environment'

def main
  crawler = ::WalkerplusEventSourceCrawler.new
  crawler.crawl
end

case $PROGRAM_NAME
when __FILE__
  main
when /spec[^\/]*$/
end


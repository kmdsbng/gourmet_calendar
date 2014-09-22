# -*- encoding: utf-8 -*-
require 'fileutils'
require 'digest/sha1'
require 'open-uri'
require 'nokogiri'
require 'net/https'

FileUtils.cd(File.dirname(__FILE__))
require './../../config/environment'

def main
  crawler = ::LeafEventSourceCrawler.new
  crawler.crawl
end

case $PROGRAM_NAME
when __FILE__
  main
when /spec[^\/]*$/
end


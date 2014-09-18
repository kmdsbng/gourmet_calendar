# -*- encoding: utf-8 -*-
require 'fileutils'
require 'digest/sha1'
require 'open-uri'
require 'nokogiri'
require 'net/https'

FileUtils.cd(File.dirname(__FILE__))
require './../../config/environment'

def main
  url = 'http://www.leafkyoto.net/event/detail/496'
  content, _error_on_load = EventSourceImporter.new.load_web_content(url)
  content.size # => 116725
  doc = Nokogiri::HTML(content)
  title = doc.title.maybe.split('イベント詳細')[0].end.to_s.strip
  _title = title # => "極上肉を堪能！「第1回 京都肉祭」開催決定！"
  dts = doc.xpath('//dt')
  basyo_dt = dts.detect {|e| e.text.strip == '場所'}
  place_str = basyo_dt.maybe.next_element.text.strip.end
  _place_str = place_str # => "［京都市役所前広場］（京都市・寺町御池）"
  kikan_dt = dts.detect {|e| e.text.strip == '期間'}
  range_str = kikan_dt.maybe.next_element.text.strip.gsub(/[\t\r\n]/, '').end
  _range_str = range_str # => "2014年09月27日(土)~2014年09月27日(土)"
  [title, place_str, range_str]
end

case $PROGRAM_NAME
when __FILE__
  main
when /spec[^\/]*$/
end


# -*- encoding: utf-8 -*-
require 'fileutils'
require 'digest/sha1'
require 'open-uri'
require 'nokogiri'

FileUtils.cd(File.dirname(__FILE__))
require './../../config/environment'

module EventSourceImporter
end

class EventSourceImporter::LeafEventSourceImporter
end

class EventSourceImporter::LeafEventSourceParser
end

def main
  url = 'http://www.leafkyoto.net/event/detail/496'
  content = load_web_content(url)
  content.size # => 116725
  doc = Nokogiri::HTML(content)
  title = doc.title.maybe.split('イベント詳細')[0].end.to_s.strip
  title # => "極上肉を堪能！「第1回 京都肉祭」開催決定！"
  dts = doc.xpath('//dt')
  basyo_dt = dts.detect {|e| e.text.strip == '場所'}
  place_str = basyo_dt.maybe.next_element.text.strip.end
  place_str # => "［京都市役所前広場］（京都市・寺町御池）"
  kikan_dt = dts.detect {|e| e.text.strip == '期間'}
  range_str = kikan_dt.maybe.next_element.text.strip.gsub(/[\t\r\n]/, '').end
  range_str # => "2014年09月27日(土)~2014年09月27日(土)"
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


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
  describe EventSourceImporter::LeafEventSourceParser do
    before do
      url = 'http://www.leafkyoto.net/event/detail/496'
      content, _error_code = EventSourceImporter.new.load_web_content(url)
      parser = EventSourceImporter::LeafEventSourceParser.new
      @attr, @ok = parser.parse(content)
    end

    it "success to parse" do
      expect(@ok).to eq(true)
    end

    it "has valid title" do
      expect(@attr[:title]).to eq("極上肉を堪能！「第1回 京都肉祭」開催決定！")
    end

    it "has valid place" do
      expect(@attr[:place_str]).to eq("［京都市役所前広場］（京都市・寺町御池）")
    end

    it "has valid range" do
      expect(@attr[:range_str]).to eq("2014年09月27日(土)~2014年09月27日(土)")
    end
  end

  describe EventSourceImporter do
    before do
      @importer = EventSourceImporter.new
    end

    it "detect leafkyoto.net url" do
      url = 'http://www.leafkyoto.net/event/detail/496'
      expect(@importer.detect_source_type(url)).to eq(EventSource::LEAF)
    end

    describe "save_event_source" do
      before do
        @url = 'http://example.jp/events/234'
        @source_type = 'sample source type'
        @attr = {
          title: 'sample event',
          place_str: 'place',
          range_str: '1999/1/1 - 1999/1/2',
        }
        @error_on_load = nil
        @parse_ok = nil
      end

      pending do
        context "valid event_source" do

          it "return event_source model" do
            @model = @importer.save_event_source(@url, @source_type, @attr, @error_on_load, @parse_ok)
            expect(@model.is_a?(::EventSource)).to eq(true)
          end

          it "return id" do
            pending
          end

          it "set import_success flag" do
            pending

          end

          it "has valid title" do
            expect(@model.title).to eq("sample event")
          end

          it "set blank to import_error_code" do
            pending

          end

          it "set blank to import_error_description" do
            pending

          end

          it "don't allow duplicate url" do
            pending
          end
        end
      end

      pending do
        context "has error on load" do

        end


        context "failed to parse" do

        end

      end

      #t.boolean :import_success, :default => true
      #t.string :import_error_code
      #t.text :import_error_description
    end

    describe "load_web_content" do
      context 'content exists' do
        it "return no error" do
          url = 'http://www.leafkyoto.net/event/detail/496'
          _content, error_code = @importer.load_web_content(url)
          expect(error_code).to eq(nil)
        end
      end

      context 'content not found' do
        it "return 404" do
          url = 'https://google.com/hoge'
          _content, error_code = @importer.load_web_content(url)
          expect(error_code).to eq('404')
        end
      end


    end
  end



end


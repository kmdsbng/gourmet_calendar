# -*- encoding: utf-8 -*-
class Bussan10EventSourceCrawler
  BUSSAN10_INDEX_URL_TEMPLATE = 'http://bussan10.com/b/area/AREA_ID/'
  BUSSAN10_DOMAIN = 'http://bussan10.com'
  # EventSourceの元になるクラス
  class Importee
    attr_accessor :url, :title, :range, :place

    def initialize(attr)
      @url = attr[:url]
      @title = attr[:title]
      @place = attr[:place]
      @range = attr[:range]
    end

  end

  class EventSourceDetector

    def detect_event_importees(contents=nil)
      contents ||= load_bussan10_index_contents
      values = contents.flat_map {|content|
        doc = Nokogiri::HTML(content)

        doc.css('#main .topic .topicw')[1].css('p').
          map {|box|
            text = box.text
            url = box.css('a').map {|e| e.attr(:href)}.reject(&:blank?)[0]
            lines = text.strip.gsub(/\t/, '').split("\r\n")
            range = lines.detect {|l| l =~ /^期間：/}.to_s.gsub(/^期間：/, '')
            place = lines.detect {|l| l =~ /^場所：/}.to_s.gsub(/^場所：/, '')
            {
              url: normalize_bussan10_url(url),
              title: lines[0],
              range: range,
              place: place,
            }
          }.select {|attr| attr[:url].present?}
      }
      values = values.uniq {|h| h[:url]}
      values.map {|attr|
        Importee.new(attr)
      }
    end

    def normalize_bussan10_url(url)
      url = url.to_s
      if url =~ /^http/
        url
      else
        BUSSAN10_DOMAIN + url
      end
    end

    def load_bussan10_index_contents
      [25, 26, 27, 28, 29, 30].map {|area_id|
        url = BUSSAN10_INDEX_URL_TEMPLATE.gsub('AREA_ID', area_id.to_s)
        content, _retval, _result_url = ::EventSourceImporter.new.load_web_content(url)
        sleep(1)
        content
      }
    end
  end

  class EventSourceImporter
    def import(importee)
      model = ::EventSource.where(:url => importee.url).first
      return nil if model

      model = build_event_source(importee)
      model.save!
      model
    end

    def build_event_source(importee)
      ::EventSource.new(
        :url => importee.url,
        :title => importee.title,
        :range_str => importee.range,
        :place_str => importee.place,
        :source_type => 'bussan10')
    end

  end

  def initialize(event_source_detector = EventSourceDetector.new)
    @event_source_detector = event_source_detector
  end

  def crawl
    import_bussan10_events
  end

  # retval: imported_count
  def import_bussan10_events
    importees = @event_source_detector.detect_event_importees
    importer = EventSourceImporter.new
    result = []
    importees.each {|importee|
      #model = load_event_source(importee.url)
      #next if model

      model = importer.import(importee)
      result << model if model
    }
    result
  end

  def load_event_source(url)
    ::EventSource.where(:url => url).first
  end
end


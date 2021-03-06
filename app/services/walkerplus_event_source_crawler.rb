# -*- encoding: utf-8 -*-
class WalkerplusEventSourceCrawler
  WALKERPLUS_CATEGORY_INDEX_URL_TEMPLATE = 'http://www.walkerplus.com/event_list/YYYYMM/ar0700/eg0117/'
  WALKERPLUS_DOMAIN = 'http://www.walkerplus.com'
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
      contents ||= load_walkerplus_category_index_contents
      values = contents.flat_map {|content|
        doc = Nokogiri::HTML(content)

        doc.css('#main .list-box').
          map {|box|
            {
              url: normalize_walkerplus_url(box.css('.bar h2 a').maybe.attr('href').value.end),
              title: box.css('.bar h2').try(:text),
              range: box.css('.data')[0].maybe.css('.green').text.gsub(/【開催日・期間】/, '').to_s.strip.end,
              place: box.css('.data')[1].maybe.css('.red').text.gsub(/【開催場所】/, '').to_s.strip.end,
            }
          }.select {|attr| attr[:url].present?}
      }
      values = values.uniq {|h| h[:url]}
      values.map {|attr|
        Importee.new(attr)
      }
    end

    def normalize_walkerplus_url(url)
      url = url.to_s
      if url =~ /^http/
        url
      else
        WALKERPLUS_DOMAIN + url
      end
    end

    def load_walkerplus_category_index_contents
      this_month = Date.today.beginning_of_month
      [this_month, this_month.next_month, this_month.months_since(2)].map {|month|
        url = WALKERPLUS_CATEGORY_INDEX_URL_TEMPLATE.gsub('YYYYMM', month.strftime('%Y%m'))
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
        :source_type => 'walkerplus')
    end

  end

  def initialize(event_source_detector = EventSourceDetector.new)
    @event_source_detector = event_source_detector
  end

  def crawl
    import_walkerplus_events
  end

  # retval: imported_count
  def import_walkerplus_events
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


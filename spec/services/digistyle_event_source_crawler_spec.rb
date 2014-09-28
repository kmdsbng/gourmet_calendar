require 'rails_helper'

describe DigistyleEventSourceCrawler do
  class MyImporter
    def initialize(result)
      @result = result
    end

    def save_event_source(importee)
      result
    end
  end

  class MyDetector
    def detect_event_source_urls
      [
        DigistyleEventSourceCrawler::Importee.new(
          url: 'http://www.digistyle-kyoto.com/event/cat524/post_8123817611.html',
          title: 'title1',
          range: '2014/9/28 - 2014/9/30',
          place: '京都市役所前'
        ),
        DigistyleEventSourceCrawler::Importee.new(
          url: 'http://www.digistyle-kyoto.com/event/cat524/post_2891.html',
          title: 'title2',
          range: '2014/9/28 - 2014/9/30',
          place: '京都市役所前'
        ),
      ]
    end

  end

  before do
    #Setting.save_leaf_event_id(100)
    my_detector = MyDetector.new
    @crawler = DigistyleEventSourceCrawler.new(my_detector)
  end

  describe "import_digistyle_events" do
    before do
      @imporeted_count = @crawler.import_digistyle_events
    end

    it "imporeted count == 2" do
      expect(@imported_count).to eq(2)
    end
  end

end

describe LeafEventSourceCrawler::EventSourceDetector do
  it "detect event source from Digistyle content" do

  end

end


describe LeafEventSourceCrawler::EventSourceImporter do
  it "save EventSource" do
    pending

  end

  it "reject duplicate url" do
    pending

  end

  it "accept different url" do
    pending

  end

end





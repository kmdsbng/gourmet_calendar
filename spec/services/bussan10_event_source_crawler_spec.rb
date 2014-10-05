require 'rails_helper'

describe Bussan10EventSourceCrawler do
  class MyBussan10Detector
    def detect_event_importees
      [
        Bussan10EventSourceCrawler::Importee.new(
          url: 'http://www.digistyle-kyoto.com/event/cat524/post_8123817611.html',
          title: 'title1',
          range: '2014/9/28 - 2014/9/30',
          place: '京都市役所前'
        ),
        Bussan10EventSourceCrawler::Importee.new(
          url: 'http://www.digistyle-kyoto.com/event/cat524/post_2891.html',
          title: 'title2',
          range: '2014/9/28 - 2014/9/30',
          place: '京都市役所前'
        ),
      ]
    end

  end

  before do
    my_detector = MyBussan10Detector.new
    @crawler = Bussan10EventSourceCrawler.new(my_detector)
    @importees = my_detector.detect_event_importees
  end

  describe "import_walkeprlus_events" do
    before do
      @imported_event_sources = @crawler.import_bussan10_events
    end

    it "imporeted count == 2" do
      expect(@imported_event_sources.size).to eq(2)
    end

    it "has valid url" do
      expect(@imported_event_sources[0].url).to eq(@importees[0].url)
    end

    it "has valid title" do
      expect(@imported_event_sources[0].title).to eq(@importees[0].title)
    end

    it "has valid range" do
      expect(@imported_event_sources[0].range_str).to eq(@importees[0].range)
    end

    it "has valid place" do
      expect(@imported_event_sources[0].place_str).to eq(@importees[0].place)
    end

    it "has import_success" do
      expect(@imported_event_sources[0].import_success).to eq(true)
    end

    it "has no import_error_code" do
      expect(@imported_event_sources[0].import_error_code).to eq(nil)
    end

    it "has not ignored" do
      expect(@imported_event_sources[0].ignored).to eq(false)
    end

    it "has not event_created" do
      expect(@imported_event_sources[0].event_created).to eq(false)
    end

    it "has valid source_type" do
      expect(@imported_event_sources[0].source_type).to eq('bussan10')
    end
  end

end

describe Bussan10EventSourceCrawler::EventSourceDetector do
  before do
    @detector = ::Bussan10EventSourceCrawler::EventSourceDetector.new
    content = File.read(File.dirname(__FILE__) + '/../data/cf6f1ecc116982257017e0b2226fa769ec8e8189a07e5f1d168fd7006cf1e7a4')
    @importees = @detector.detect_event_importees([content])
  end

  it "detect 50 events" do
    expect(@importees.count).to eq(50)
  end

  it "has valid title" do
    expect(@importees[0].title).to eq("秋の大北海道市（京都）")
  end

  it "has valid url" do
    expect(@importees[0].url).to eq("http://bussan10.com/b/d/3525/")
  end

  it "has valid place" do
    expect(@importees[0].place).to eq("大丸京都店")
  end

  it "has valid range" do
    expect(@importees[0].range).to eq("2014/10/22 〜 2014/10/28")
  end

  it "load bussan10 index" do
    expect(@detector.load_bussan10_index_contents).to be_present
  end
end


describe Bussan10EventSourceCrawler::EventSourceImporter do
  before do
    @importee = ::Bussan10EventSourceCrawler::Importee.new(:url => 'http://example.com')
    @importer = ::Bussan10EventSourceCrawler::EventSourceImporter.new
    @event_source = @importer.import(@importee)
  end

  it "save EventSource" do
    expect(@event_source).to be_present
  end

  it "reject duplicate url" do
    event_source2 = @importer.import(@importee)
    expect(event_source2).to be_nil
  end

  it "accept different url" do
    importee2 = ::Bussan10EventSourceCrawler::Importee.new(:url => 'http://example2.com')
    event_source2 = @importer.import(importee2)
    expect(event_source2).to be_present
  end

end





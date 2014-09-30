require 'rails_helper'

describe WalkerplusEventSourceCrawler do
  class MyWalkerplusDetector
    def detect_event_importees
      [
        WalkerplusEventSourceCrawler::Importee.new(
          url: 'http://www.digistyle-kyoto.com/event/cat524/post_8123817611.html',
          title: 'title1',
          range: '2014/9/28 - 2014/9/30',
          place: '京都市役所前'
        ),
        WalkerplusEventSourceCrawler::Importee.new(
          url: 'http://www.digistyle-kyoto.com/event/cat524/post_2891.html',
          title: 'title2',
          range: '2014/9/28 - 2014/9/30',
          place: '京都市役所前'
        ),
      ]
    end

  end

  before do
    my_detector = MyWalkerplusDetector.new
    @crawler = WalkerplusEventSourceCrawler.new(my_detector)
    @importees = MyWalkerplusDetector.new.detect_event_importees
  end

  describe "import_walkeprlus_events" do
    before do
      @imported_event_sources = @crawler.import_walkerplus_events
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
      expect(@imported_event_sources[0].source_type).to eq('walkerplus')
    end
  end

end

describe WalkerplusEventSourceCrawler::EventSourceDetector do
  before do
    @detector = ::WalkerplusEventSourceCrawler::EventSourceDetector.new
    content = File.read(File.dirname(__FILE__) + '/../data/b1abaac19ed17e1a55e81b1f655aba674190edd34d02a449da65af81eea916a8')
    @importees = @detector.detect_event_importees([content])
  end

  it "detect 11 events" do
    expect(@importees.count).to eq(11)
  end

  it "has valid title" do
    expect(@importees[0].title).to eq("初秋の陶芸ランチ")
  end

  it "has valid url" do
    expect(@importees[0].url).to eq("http://www.walkerplus.com/event/ar0725e79968/")
  end

  it "has valid place" do
    expect(@importees[0].place).to eq("水茎焼陶芸の里")
  end

  it "has valid range" do
    expect(@importees[0].range).to eq("9/1(月)～30(火)※水・土・日・祝日と22日は未開催。　10:30～陶芸教室（手廻しロクロ）　12:00～琵琶湖・旬の幸を使ったランチ・デザート付き　13:00～おしゃべりタイム（珈琲・紅茶おかわり自由）　15:00お開き（退場自由）")
  end

  it "load walkerplus category index" do
    expect(@detector.load_walkerplus_category_index_contents).to be_present
  end
end


describe WalkerplusEventSourceCrawler::EventSourceImporter do
  before do
    @importee = ::WalkerplusEventSourceCrawler::Importee.new(:url => 'http://example.com')
    @importer = ::WalkerplusEventSourceCrawler::EventSourceImporter.new
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
    importee2 = ::WalkerplusEventSourceCrawler::Importee.new(:url => 'http://example2.com')
    event_source2 = @importer.import(importee2)
    expect(event_source2).to be_present
  end

end





require 'rails_helper'

describe DigistyleEventSourceCrawler do
  #class MyImporter
  #  def initialize(result)
  #    @result = result
  #  end

  #  def save_event_source(importee)
  #    result
  #  end
  #end

  class MyDigistyleDetector
    def detect_event_importees
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
    my_detector = MyDigistyleDetector.new
    @crawler = DigistyleEventSourceCrawler.new(my_detector)
    @importees = MyDigistyleDetector.new.detect_event_importees
  end

  describe "import_digistyle_events" do
    before do
      @imported_event_sources = @crawler.import_digistyle_events
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
      expect(@imported_event_sources[0].source_type).to eq('digistyle')
    end
  end

end

describe DigistyleEventSourceCrawler::EventSourceDetector do
  before do
    @detector = ::DigistyleEventSourceCrawler::EventSourceDetector.new
    content = File.read(File.dirname(__FILE__) + '/../data/74775266bebea98d9d3f261ff3efd1ed4941ef62de4a1af62a98f7a7b6774525')
    @importees = @detector.detect_event_importees(content)
  end

  it "detect 4 events" do
    expect(@importees.count).to eq(4)
  end

  it "has valid title" do
    expect(@importees[0].title).to eq("おいしおすえ京野菜フェスティバル")
  end

  it "has valid url" do
    expect(@importees[0].url).to eq("http://www.digistyle-kyoto.com/event/cat524/post_8123817611.html")
  end

  it "has valid place" do
    expect(@importees[0].place).to eq("会場：梅小路公園")
  end

  it "has valid range" do
    expect(@importees[0].range).to eq("2014年11月 1日～2014年11月 3日")
  end

  it "load digistyle category index" do
    expect(@detector.load_digistyle_category_index_content).to be_present
  end
end


describe DigistyleEventSourceCrawler::EventSourceImporter do
  before do
    @importee = ::DigistyleEventSourceCrawler::Importee.new(:url => 'http://example.com')
    @importer = ::DigistyleEventSourceCrawler::EventSourceImporter.new
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
    importee2 = ::DigistyleEventSourceCrawler::Importee.new(:url => 'http://example2.com')
    event_source2 = @importer.import(importee2)
    expect(event_source2).to be_present
  end

end





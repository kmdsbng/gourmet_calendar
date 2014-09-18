require 'rails_helper'

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

    context "valid event_source" do
      before do
        @model = @importer.save_event_source(@url, @source_type, @attr, @error_on_load, @parse_ok)
      end

      it "return event_source model" do
        expect(@model.is_a?(::EventSource)).to eq(true)
      end

      it "return id" do
        expect(@model.id > 0).to eq(true)
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





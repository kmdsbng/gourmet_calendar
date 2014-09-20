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
      @parse_ok = true
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
        expect(@model.import_success).to eq(true)
      end

      it "has valid title" do
        expect(@model.title).to eq("sample event")
      end

      it "set blank to import_error_code" do
        expect(@model.import_error_code).to be_blank
      end

      it "set blank to import_error_description" do
        expect(@model.import_error_description).to be_blank
      end

      context "doesn't allow duplicate url" do
        it "before 1 row" do
          before_count = ::EventSource.where(:url => @url).count
          expect(before_count).to eq(1)
        end

        it "after 1 row" do
          @importer.save_event_source(@url, @source_type, @attr, @error_on_load, @parse_ok)
          after_count = ::EventSource.where(:url => @url).count
          expect(after_count).to eq(1)
        end
      end

      context "allows different url" do
        it "before 0 row" do
          before_count = ::EventSource.where(:url => @url + '5').count
          expect(before_count).to eq(0)
        end

        it "after 1 row" do
          @importer.save_event_source(@url + '5', @source_type, @attr, @error_on_load, @parse_ok)
          after_count = ::EventSource.where(:url => @url).count
          expect(after_count).to eq(1)
        end
      end
    end

    context "has error on load" do
      before do
        @error_on_load = '404'
        @model = @importer.save_event_source(@url, @source_type, @attr, @error_on_load, @parse_ok)
      end

      it "set import_success false" do
        expect(@model.import_success).to eq(false)
      end

      it "set 404 to import_error_code" do
        expect(@model.import_error_code).to eq('404')
      end

    end


    context "failed to parse" do
      before do
        @parse_ok = false
        @model = @importer.save_event_source(@url, @source_type, @attr, @error_on_load, @parse_ok)
      end

      it "set import_success false" do
        expect(@model.import_success).to eq(false)
      end

      it "set parse error to import_error_code" do
        expect(@model.import_error_code).to eq('parse failed')
      end

    end

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

  describe "import" do
    context "valid url" do
      it "return import_success" do
        url = 'http://www.leafkyoto.net/event/detail/496'
        event_source = @importer.import(url)
        expect(event_source.import_success).to eq(true)
      end
    end

    context "shortend url" do
      before do
        @url = 'http://goo.gl/MxL9Mq'
        @event_source = @importer.import(@url)
      end

      it "return import_success" do
        expect(@event_source.import_success).to eq(true)
      end

      it "has blank import_error_code" do
        expect(@event_source.import_error_code).to eq(nil)
      end

      it "has expanded url" do
        expanded_url = 'http://www.leafkyoto.net/event/detail/496'
        expect(@event_source.url).to eq(expanded_url)
      end
    end

    context "invalid domain" do
      it "return import failes" do
        url = 'http://example.com/'
        event_source = @importer.import(url)
        expect(event_source.import_success).to eq(false)
      end
    end

    context "404 url" do
      it "return import failes" do
        url = 'http://google.com/hoge'
        event_source = @importer.import(url)
        expect(event_source.import_success).to eq(false)
      end

      it "return 404 error_code" do
        url = 'http://www.google.com/hoge'
        event_source = @importer.import(url)
        expect(event_source.import_error_code).to eq('404')
      end
    end

    context "blank url" do
      it "raise error" do
        expect {
          url = ''
          @importer.import(url)
        }.to raise_error
      end
    end
  end
end





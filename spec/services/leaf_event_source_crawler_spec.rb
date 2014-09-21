require 'rails_helper'

describe LeafEventSourceCrawler do
  class MyImporter
    def import(url)

      valid_urls = %w(
        http://www.leafkyoto.net/event/detail/100
        http://www.leafkyoto.net/event/detail/101
        http://www.leafkyoto.net/event/detail/102
        http://www.leafkyoto.net/event/detail/103
        http://www.leafkyoto.net/event/detail/104
      )

      result = ::EventSource.new
      unless valid_urls.include?(url)
        result.import_success = false
        result.import_error_code = '404'
      end
      result
    end
  end

  before do
    Setting.save_leaf_event_id(100)
    my_importer = MyImporter.new
    @crawler = LeafEventSourceImporter.new(my_importer)
  end

  describe "load_leaf_event_id" do
    it "load valid event_id" do
      expect(@crawler.load_leaf_event_id).to eq(100)
    end
  end

  describe "import_leaf_events" do
    before do
      @finished_event_id = @crawler.import_leaf_events(100)
    end

    it "last event id == 104" do
      expect(@finished_event_id).to eq(104)
    end
  end

  describe "save_leaf_event_id" do
    before do
      @crawler.save_leaf_event_id(999)
    end

    it "save last event id to specific value" do
      expect(@crawler.load_leaf_event_id).to eq(999)
    end
  end

  # describe "save_event_source" do
  #   before do
  #     @url = 'http://example.jp/events/234'
  #     @source_type = 'sample source type'
  #     @attr = {
  #       title: 'sample event',
  #       place_str: 'place',
  #       range_str: '1999/1/1 - 1999/1/2',
  #     }
  #     @error_on_load = nil
  #     @parse_ok = true
  #   end

  #   context "valid event_source" do
  #     before do
  #       @model = @importer.save_event_source(@url, @source_type, @attr, @error_on_load, @parse_ok)
  #     end

  #     it "return event_source model" do
  #       expect(@model.is_a?(::EventSource)).to eq(true)
  #     end

  #     it "return id" do
  #       expect(@model.id > 0).to eq(true)
  #     end

  #     it "set import_success flag" do
  #       expect(@model.import_success).to eq(true)
  #     end

  #     it "has valid title" do
  #       expect(@model.title).to eq("sample event")
  #     end

  #     it "set blank to import_error_code" do
  #       expect(@model.import_error_code).to be_blank
  #     end

  #     it "set blank to import_error_description" do
  #       expect(@model.import_error_description).to be_blank
  #     end

  #     it "doesn't allow duplicate url" do
  #       expect {
  #         @importer.save_event_source(@url, @source_type, @attr, @error_on_load, @parse_ok)
  #       }.to raise_error
  #     end

  #     it "allows different url" do
  #       model2 = @importer.save_event_source(@url + '5', @source_type, @attr, @error_on_load, @parse_ok)
  #       expect(model2.id > 0).to eq(true)
  #     end
  #   end

  #   context "has error on load" do
  #     before do
  #       @error_on_load = '404'
  #       @model = @importer.save_event_source(@url, @source_type, @attr, @error_on_load, @parse_ok)
  #     end

  #     it "set import_success false" do
  #       expect(@model.import_success).to eq(false)
  #     end

  #     it "set 404 to import_error_code" do
  #       expect(@model.import_error_code).to eq('404')
  #     end

  #   end


  #   context "failed to parse" do
  #     before do
  #       @parse_ok = false
  #       @model = @importer.save_event_source(@url, @source_type, @attr, @error_on_load, @parse_ok)
  #     end

  #     it "set import_success false" do
  #       expect(@model.import_success).to eq(false)
  #     end

  #     it "set parse error to import_error_code" do
  #       expect(@model.import_error_code).to eq('parse failed')
  #     end

  #   end

  # end

  # describe "load_web_content" do
  #   context 'content exists' do
  #     it "return no error" do
  #       url = 'http://www.leafkyoto.net/event/detail/496'
  #       _content, error_code = @importer.load_web_content(url)
  #       expect(error_code).to eq(nil)
  #     end
  #   end

  #   context 'content not found' do
  #     it "return 404" do
  #       url = 'https://google.com/hoge'
  #       _content, error_code = @importer.load_web_content(url)
  #       expect(error_code).to eq('404')
  #     end
  #   end

  # end
end





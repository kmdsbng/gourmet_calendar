require 'rails_helper'

describe EventSourceImporter::LeafEventSourceParser do
  before do
    url = 'http://www.leafkyoto.net/event/detail/496'
    content, _error_code = ::EventSourceImporter.new.load_web_content(url)
    parser = ::EventSourceImporter::LeafEventSourceParser.new
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

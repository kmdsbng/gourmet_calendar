# -*- encoding: utf-8 -*-
class EventSourceImporter::LeafEventSourceParser
  def parse(content)
    doc = Nokogiri::HTML(content)
    title = doc.title.maybe.split('イベント詳細')[0].end.to_s.strip
    dts = doc.xpath('//dt')
    basyo_dt = dts.detect {|e| e.text.strip == '場所'}
    place_str = basyo_dt.maybe.next_element.text.strip.end
    kikan_dt = dts.detect {|e| e.text.strip == '期間'}
    range_str = kikan_dt.maybe.next_element.text.strip.gsub(/[\t\r\n]/, '').end
    [
      {
        title: title,
        place_str: place_str,
        range_str: range_str,
      },
      title.present? && place_str.present? && range_str.present?
    ]
  end
end


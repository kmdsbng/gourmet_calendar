# -*- encoding: utf-8 -*-
class EventSourceImporter
  def import(url)
    source_type = detect_source_type(url)
    parser = get_parser(source_type)
    content, error_on_load = load_web_content(url)
    event_source_attr, parse_ok = parser.parse(content)
    save_event_source(url, source_type, event_source_attr, error_on_load, parse_ok)
  end

  def save_event_source(url, source_type, event_source_attr, error_on_load, parse_ok)
    EventSource.create!(:url => url)
  end

  def detect_source_type(url)
    if url =~ /www\.leafkyoto\.net/
      ::EventSource::LEAF
    end
  end
end


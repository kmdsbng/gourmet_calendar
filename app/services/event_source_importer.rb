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

  def load_web_content(url)
    fname = Rails.root + ('cache/' + Digest::SHA256.hexdigest(url))
    if File.exist?(fname)
      content = File.read(fname)
      content.size # => 116725
      [content, nil]
    else

      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      res = http.start {|proto|
        proto.get(uri.path)
      }
      if res.code == '200'
        content = res.body
        open(fname, 'wb') {|out|
          out.write content
        }
        [content, nil]
      else
        [nil, res.code]
      end
    end
  end

end

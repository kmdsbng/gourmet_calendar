# -*- encoding: utf-8 -*-
class EventSourceImporter
  def import(url)
    raise "url is blank" if url.blank?
    content, error_on_load, result_url = load_web_content(url)
    source_type = detect_source_type(result_url)
    parser = get_parser(source_type)
    if parser
      event_source_attr, parse_ok = parser.parse(content)
    else
      event_source_attr, parse_ok = {}, false
    end
    save_event_source(result_url, source_type, event_source_attr, error_on_load, parse_ok)
  end

  def save_event_source(url, source_type, event_source_attr, error_on_load, parse_ok)
    if error_on_load.present?
      error_code = error_on_load
      import_success = false
    elsif !parse_ok
      error_code = 'parse failed'
      import_success = false
    else
      import_success = true
    end
    attr = event_source_attr.merge(
      :url => url, :source_type => source_type, :import_error_code => error_code, :import_success => import_success)
    existed_event_source = EventSource.where(:url => url).first
    if existed_event_source
      existed_event_source.attributes = attr
    else
      ::EventSource.create!(attr)
    end
  end

  def detect_source_type(url)
    if url =~ /www\.leafkyoto\.net/
      ::EventSource::LEAF
    end
  end

  def get_parser(source_type)
    case source_type
    when ::EventSource::LEAF
      ::EventSourceImporter::LeafEventSourceParser.new
    end
  end

  # retval: content, retval, result_url
  def load_web_content(url)
    appended_urls = Set.new([])
    origin_url = url

    while true
      fname = Rails.root + ('cache/' + Digest::SHA256.hexdigest(url))
      if File.exist?(fname)
        content = File.read(fname)
        content.size # => 116725
        return [content, nil, url]
      else

        if appended_urls.include?(url)
          return [nil, 'cycle redirect', origin_url]
        end
        appended_urls << url
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if uri.scheme == 'https'
        res = http.start {|proto|
          proto.get(uri.path)
        }
        if res.code == '200'
          content = res.body
          fname = Rails.root + ('cache/' + Digest::SHA256.hexdigest(url))
          open(fname, 'wb') {|out|
            out.write content
          }
          return [content, nil, url]
        elsif res.code =~ /^3[0-9]{2}$/
          url = res['location']
          next
        else
          return [nil, res.code, url]
        end
      end
    end
  end

end


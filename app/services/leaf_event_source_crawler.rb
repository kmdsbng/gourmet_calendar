# -*- encoding: utf-8 -*-
class LeafEventSourceCrawler

  def initialize(event_source_importer = EventSourceImporter.new)
    @event_source_importer = event_source_importer
  end

  def crawl
    last_event_id = load_leaf_event_id
    finished_event_id = import_leaf_events(last_event_id + 1)
    save_leaf_event_id(finished_event_id) if finished_event_id > last_event_id
  end

  def load_leaf_event_id
    ::Setting.load_leaf_event_id
  end

  def save_leaf_event_id(event_id)
    ::Setting.save_leaf_event_id(event_id)
  end

  def import_leaf_events(event_id)
    last_import_success_id = event_id - 1
    current_id = event_id
    failed_count = 0
    while true
      url = "http://www.leafkyoto.net/event/detail/#{current_id}"
      event_source = @event_source_importer.import(url)
      if event_source.import_success
        failed_count = 0
        last_import_success_id = current_id
      else
        failed_count += 1
        if failed_count >= 5
          return last_import_success_id
        end
      end
      sleep 1
      current_id += 1
    end
  end
end


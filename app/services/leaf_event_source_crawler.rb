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
  end

end


class EventSourcesController < ApplicationController

  def todos_json
    models = ::EventSource.order('id desc').where(:import_success => true, :ignored => false).all
    model_jsons = to_jsons(models)
    render :json => { eventSources: model_jsons }
  end

  def ignoreds_json
    models = ::EventSource.order('id desc').where(:import_success => true, :ignored => true).all
    model_jsons = to_jsons(models)
    render :json => { eventSources: model_jsons }
  end

  def event_createds_json
    models = ::EventSource.order('id desc').where(:import_success => true, :event_created => true).all
    model_jsons = to_jsons(models)
    render :json => { eventSources: model_jsons }
  end

  private
  def to_jsons(models)
    models.map {|model|
      {
        id: model.id,
        title: model.title,
        url: model.url,
        place: model.place_str,
        range: model.range_str,
        import_success: model.import_success,
        ignored: model.ignored,
        event_created: model.event_created,
        source_type: model.source_type,
      }
    }
  end
end

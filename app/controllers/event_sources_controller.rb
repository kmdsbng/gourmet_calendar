class EventSourcesController < ApplicationController

  def todos_json
    models = ::EventSource.all
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
      }
    }
  end
end

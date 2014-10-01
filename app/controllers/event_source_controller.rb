class EventSourceController < ApplicationController

  def ignored
    ActiveRecord::Base.transaction {
      ::EventSource.find(params[:id]).update_attribute(:ignored, true)
      render :json => { state: 'success' }
    }
  end

  def cancel_ignored
    ActiveRecord::Base.transaction {
      ::EventSource.find(params[:id]).update_attribute(:ignored, false)
      render :json => { state: 'success' }
    }
  end

  def event_created
    ActiveRecord::Base.transaction {
      ::EventSource.find(params[:id]).update_attribute(:event_created, true)
      render :json => { state: 'success' }
    }
  end

  def cancel_event_created
    ActiveRecord::Base.transaction {
      ::EventSource.find(params[:id]).update_attribute(:event_created, false)
      render :json => { state: 'success' }
    }
  end
end

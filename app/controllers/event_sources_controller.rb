class EventSourcesController < ApplicationController

  def todos_json
    render :json => {
      eventSources: [
        {title: 'aaa'   , url: 'http://www.yahoo.co.jp', place: 'kyoto', range: 'iPhone 5'},
        {title: 'Sporting Goods', url: 'http://www.yahoo.co.jp' , place: 'kyoto', range: 'Basketball'},
        {title: 'Electronics'   , url: 'http://www.yahoo.co.jp', place: 'kyoto', range: 'iPhone 5'},
      ]
    }
  end
end

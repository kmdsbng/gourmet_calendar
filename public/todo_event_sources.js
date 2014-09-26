/** @jsx React.DOM */

var EventSourceRow = React.createClass({
  render: function() {
    var eventSource = this.props.eventSource;
    return (
      <tr>
        <td>
          {eventSource.id}
        </td>
        <td>
          <a href={eventSource.url} target="_blank">{eventSource.title}</a>
        </td>
        <td>
          {eventSource.place}
        </td>
        <td>
          {eventSource.range}
        </td>
        <td>
          <input type="checkbox" checked={eventSource.eventCreated} />イベント作成済み
          &nbsp;
          <input type="checkbox" checked={eventSource.ignored} />無視
        </td>
      </tr>
    );
  }
});

var EventSourceTable = React.createClass({
  //handleUserInput: function(filterText, inStockOnly) {
  //    this.setState({
  //        filterText: filterText,
  //        inStockOnly: inStockOnly
  //    });
  //},
  
  loadEventSourcesFromServer: function() {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      success: function(data) {
        this.setState({eventSources: data.eventSources});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  getInitialState: function() {
    return {
      eventSources: [
        {id: 0, title: 'title', url: 'url'  , place: 'place', range: 'range'}
      ]
    };
  },
  componentDidMount: function() {
    this.loadEventSourcesFromServer();
  },
  render: function() {
    var rows = [];
    this.state.eventSources.forEach(function(eventSource) {
      rows.push(<EventSourceRow eventSource={eventSource} />);
    }.bind(this));
    return (
      <div className="table-responsive">
        <table className="table table-striped table-bordered">
          <thead>
            <tr>
              <th>
                ID
              </th>
              <th>
                タイトル
              </th>
              <th>
                場所
              </th>
              <th width="200">
                期間
              </th>
              <th width="200">
              </th>
            </tr>
          </thead>
          <tbody>
            {rows}
          </tbody>
        </table>
      </div>
    );
  }
});

React.renderComponent(<EventSourceTable url="/event_sources/todos_json" />, $('#MainTable')[0]);


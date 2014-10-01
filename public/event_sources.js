/** @jsx React.DOM */

var EventSourceRow = React.createClass({
  getInitialState: function() {
    var eventSource = this.props.eventSource;
    return {
      event_created: eventSource.event_created,
      ignored: eventSource.ignored
    };
  },
  handleChangeEventCreated: function(e) {
    this.props.handleEventCreated(this.props.eventSource.id, e.target.checked);
    var state = this.state;
    state.event_created = e.target.checked;
    this.setState(state);
  },
  handleChangeIgnored: function(e) {
    this.props.handleIgnored(this.props.eventSource.id, e.target.checked);
    var state = this.state;
    state.ignored = e.target.checked;
    this.setState(state);
  },
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
          {eventSource.source_type}
        </td>
        <td>
          {eventSource.place}
        </td>
        <td>
          {eventSource.range}
        </td>
        <td>
          <label>
            <input type="checkbox" checked={this.state.event_created} onChange={this.handleChangeEventCreated} />イベント作成済み
          </label>
          &nbsp;
          <label>
            <input type="checkbox" checked={this.state.ignored} onChange={this.handleChangeIgnored} />無視
          </label>
        </td>
      </tr>
    );
  }
});

var EventSourceTable = React.createClass({
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
        //{id: 0, title: 'title', url: 'url'  , place: 'place', range: 'range'}
      ]
    };
  },
  componentDidMount: function() {
    this.loadEventSourcesFromServer();
  },
  handleEventCreated: function(eventSourceId, value) {
    console.log('EventSourceTable.handleEventCreated:' + eventSourceId + ' ' + value);
    var url = (value ? '/event_source/event_created/' : '/event_source/cancel_event_created/') + eventSourceId;
    this.putRequest(url);
  },
  handleIgnored: function(eventSourceId, value) {
    console.log('EventSourceTable.handleIgnored:' + eventSourceId + ' ' + value);
    var url = (value ? '/event_source/ignored/' : '/event_source/cancel_ignored/') + eventSourceId;
    this.putRequest(url);
  },
  putRequest: function(url, data) {
    if (!data)
      data = {};

    var error = function (xhr) {
      alert(url + ' error :' + xhr.status + ' ' + xhr.statusText);
    }
    $.ajax({
      url: url,
      type: 'PUT',
      cache: false,
      error: error
    })
  },
  render: function() {
    var rows = [];
    this.state.eventSources.forEach(function(eventSource) {
      rows.push(<EventSourceRow eventSource={eventSource} handleEventCreated={this.handleEventCreated} handleIgnored={this.handleIgnored} />);
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
              <th width="60">
                情報元
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

React.renderComponent(<EventSourceTable url={list_url} />, $('#MainTable')[0]);


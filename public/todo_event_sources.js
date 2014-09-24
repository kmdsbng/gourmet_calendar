/** @jsx React.DOM */

var EventSourceRow = React.createClass({
    render: function() {
        //var name = this.props.product.stocked ?
        //    this.props.product.name :
        //    <span style={{color: 'red'}}>
        //        {this.props.product.name}
        //    </span>;
        var eventSource = this.props.eventSource;
        return (
          <tr>
            <td>
              <a href={eventSource.url}>{eventSource.title}</a>
            </td>
            <td>
              <a href={eventSource.url}>{eventSource.url}</a>
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
  //getInitialState: function() {
  //    return {
  //        filterText: '',
  //        inStockOnly: false
  //    };
  //},
  //
  //handleUserInput: function(filterText, inStockOnly) {
  //    this.setState({
  //        filterText: filterText,
  //        inStockOnly: inStockOnly
  //    });
  //},
  
  render: function() {
    var rows = [];
    this.props.eventSources.forEach(function(eventSource) {
      rows.push(<EventSourceRow eventSource={eventSource} />);
    }.bind(this));
    return (
      <div className="table-responsive">
        <table className="table table-striped table-bordered">
          {rows}
        </table>
      </div>
    );
  }
});

var EVENT_SOURCES = [
  {title: 'Sporting Goods', url: 'http://www.yahoo.co.jp' , place: 'kyoto', range: 'Football'},
  {title: 'Sporting Goods', url: 'http://www.yahoo.co.jp'  , place: 'kyoto', range: 'Baseball'},
  {title: 'Sporting Goods', url: 'http://www.yahoo.co.jp' , place: 'kyoto', range: 'Basketball'},
  {title: 'Electronics'   , url: 'http://www.yahoo.co.jp' , place: 'kyoto', range: 'iPod Touch'},
  {title: 'Electronics'   , url: 'http://www.yahoo.co.jp', place: 'kyoto', range: 'iPhone 5'},
  {title: 'Electronics'   , url: 'http://www.yahoo.co.jp', place: 'kyoto', range: 'Nexus 7', eventCreated: true, ignored: true}
];
React.renderComponent(<EventSourceTable eventSources={EVENT_SOURCES} />, $('#MainTable')[0]);


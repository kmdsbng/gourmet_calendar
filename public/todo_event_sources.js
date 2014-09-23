/** @jsx React.DOM */

var EventSourceRow = React.createClass({
    render: function() {
        //var name = this.props.product.stocked ?
        //    this.props.product.name :
        //    <span style={{color: 'red'}}>
        //        {this.props.product.name}
        //    </span>;
        return (
          <li>
            event source
          </li>
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
      <ul>
        {rows}
      </ul>
    );
  }
});

var EVENT_SOURCES = [
  {title: 'Sporting Goods', url: '$49.99' , place: 'kyoto', range: 'Football'},
  {title: 'Sporting Goods', url: '$9.99'  , place: 'kyoto', range: 'Baseball'},
  {title: 'Sporting Goods', url: '$29.99' , place: 'kyoto', range: 'Basketball'},
  {title: 'Electronics'   , url: '$99.99' , place: 'kyoto', range: 'iPod Touch'},
  {title: 'Electronics'   , url: '$399.99', place: 'kyoto', range: 'iPhone 5'},
  {title: 'Electronics'   , url: '$199.99', place: 'kyoto', range: 'Nexus 7'}
];
React.renderComponent(<EventSourceTable eventSources={EVENT_SOURCES} />, $('#MainTable')[0]);


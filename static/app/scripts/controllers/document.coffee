controller = (scope, params, ParseCrud, timeout, http, location, Alert)->

  id = params.id
  scope.id = params.id

  scope.text = ''
  scope.entity = {}
  scope.selected = 'document'

  Processes = new ParseCrud 'Processes'
  Processes.getWith params.id, ['wordslist', 'documents'], (d)->
    scope.$apply ->
      scope.entity = d
      scope.graph()

  scope.remove = (entity)->
    entity.destroy
      success: ->
        scope.$apply ->
          Alert.success 'Removed successfully.'
          location.path('/processes')
      error: (e)->
        scope.$apply ->
          console.log e
          Alert.error 'Error occurred while removing.'
  
  scope.save = (entity)->
    # console.log entity.get('result');

    data = []
    for key in Object.keys entity.attributes.result 
      entry = entity.attributes.result[key]
      data += entry['name'] + "," + entry['freq'] + "\n" 
      #data.push {name: entry.name, freq: entry.freq}

    console.log data
    
    # Create a hidden element to trigger download...
    hiddenElement = document.createElement('a')
    hiddenElement.href = 'data:attachment/csv,' + encodeURI(data)
    hiddenElement.target = '_blank'
    hiddenElement.download = 'analyzeresult_' + Date.now() + '.csv'
    hiddenElement.click()

    
  scope.graph = ->
    margin =
      top: 40
      right: 20
      bottom: 80
      left: 40

    width = 960 - margin.left - margin.right
    height = 550 - margin.top - margin.bottom
    # formatPercent = d3.format(".0%")
    formatPercent = d3.format("03d")

    x = d3.scale.ordinal().rangeRoundBands([0, width], .1)
    y = d3.scale.linear().range([height, 0])

    xAxis = d3.svg.axis().scale(x).orient("bottom")
    # yAxis = d3.svg.axis().scale(y).orient("left").tickFormat(formatPercent)
    yAxis = d3.svg.axis().scale(y).orient("left").ticks(10)

    tip = d3.tip().attr("class", "d3-tip").offset([-10, 0]).html((d) ->
      "<strong>Frequency:</strong> <span style='color:red'>" + d.frequency + "</span>"
    )

    #main data points...
    svg = d3.select("#chart").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    svg.call tip

    data = _.map scope.entity.get('result'), (d)->
      word: d.name
      frequency: d.freq * 100

    x.domain data.map((d) -> d.word)
    y.domain [0, d3.max(data, (d) -> d.frequency)]

    svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis)
      .selectAll("text")
      .style("text-anchor", "end")
      .attr("transform", (d)-> "rotate(-65)")

      svg.append("g").attr("class", "y axis").call(yAxis)
    # svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text "Frequency"
   
    svg.selectAll(".bar").data(data).enter().append("rect").attr("class", "bar").attr("x", (d) ->
      x d.word
    ).attr("width", x.rangeBand()).attr("y", (d) ->
      y d.frequency
    ).attr("height", (d) ->
      height - y(d.frequency)
    ).on("mouseover", tip.show).on "mouseout", tip.hide

angular.module('wordsApp')
  .controller 'ProcessedDocumentCtrl',
  ['$scope', '$routeParams', 'ParseCrud', '$timeout', '$http', '$location', 'Alert', controller]

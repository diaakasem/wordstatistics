controller = (scope, params, Service, timeout, http)->

  id = params.id
  scope.id = params.id

  scope.text = ''
  scope.entity = {}
  scope.success = ''
  scope.error = ''
  scope.selected = 'document'

  Service.get id, (d)->
    scope.$apply ->
      scope.entity = d
      load(d)
      scope.graph()

  removeFile = (name)->
    params =
      method: 'POST'
      url: '/remove'
      data:
        filename: name
    h = http params
    h.success (d)->
      scope.success = 'Removed successfully.'
      timeout -> scope.go 'documents', 5000
    h.error (e)->
      scope.success = ''
      scope.error = e

  load = (d)->
    params =
      method: 'POST'
      url: '/load'
      data:
        filename: d.get('filename')
    h = http params
    h.success (d)->
      scope.text = d
      scope.success = ''
      scope.error = ''
    h.error (e)->
      scope.success = ''
      scope.error = e

  scope.remove = (e)->
    filename = e.get('filename')
    removeSuccess = -> removeFile filename
    Service.remove(e, removeSuccess)

  scope.graph = ->
    margin =
      top: 40
      right: 20
      bottom: 30
      left: 40

    width = 960 - margin.left - margin.right
    height = 500 - margin.top - margin.bottom
    formatPercent = d3.format(".0%")
    x = d3.scale.ordinal().rangeRoundBands([0, width], .1)
    y = d3.scale.linear().range([height, 0])
    xAxis = d3.svg.axis().scale(x).orient("bottom")
    yAxis = d3.svg.axis().scale(y).orient("left").tickFormat(formatPercent)
    tip = d3.tip().attr("class", "d3-tip").offset([-10, 0]).html((d) ->
      "<strong>Frequency:</strong> <span style='color:red'>" + d.frequency + "</span>"
    )
    svg = d3.select("#chart").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    svg.call tip
    data = _.map scope.entity.get('results'), (d)->
      word: d[0]
      frequency: d[1] * 100

    x.domain data.map((d) -> d.word)
    y.domain [0, d3.max(data, (d) ->
      d.frequency
    )]
    svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call xAxis
    svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text "Frequency"
    svg.selectAll(".bar").data(data).enter().append("rect").attr("class", "bar").attr("x", (d) ->
      x d.word
    ).attr("width", x.rangeBand()).attr("y", (d) ->
      y d.frequency
    ).attr("height", (d) ->
      height - y(d.frequency)
    ).on("mouseover", tip.show).on "mouseout", tip.hide

angular.module('wordsApp')
  .controller 'DocumentCtrl',
  ['$scope', '$routeParams', 'Texts', '$timeout', '$http', controller]

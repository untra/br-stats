$(document).ready ->
  MARGIN =
    TOP: 20
    RIGHT: 80
    BOTTOM: 30
    LEFT: 50
  WIDTH = 960 - (MARGIN.LEFT) - (MARGIN.RIGHT)
  HEIGHT = 500 - (MARGIN.TOP) - (MARGIN.BOTTOM)
  UPLOADS = 4
  RANKS = 61
  X = d3.scale.linear()
  .range([
    0
    WIDTH
  ])
  .domain([
    0,
    UPLOADS
  ])
  Y = d3.scale.linear()
  .range([
    HEIGHT
    0
  ])
  .domain([
    1,
    RANKS
  ])
  self= @
  xAxis = d3.svg.axis().scale(X).orient('bottom')
  yAxis = d3.svg.axis().scale(Y).orient('left')
  console.log "'Sup kid. Good on you for looking at the console. Doesn't say much, but it means you care. <3 untra"

  svg = d3.select('#linechart').append('svg')
  .attr('width', WIDTH + MARGIN.LEFT + MARGIN.RIGHT)
  .attr('height', HEIGHT + MARGIN.TOP + MARGIN.BOTTOM)
  .append('g').attr('transform', 'translate(' + MARGIN.LEFT + ',' + MARGIN.TOP + ')')

  datapoints = [
    'civs.csv'
    'civs.csv'
    'civs.csv'
  ]
  rankings = {}
  civdata = {}
  civs = []
  remaining = 2

  to_hash = (data, name) ->
    hash = {}
    for d in data
      hash[d[name]] = d
    hash

  to_array = (data, name) ->
    arr = []
    for d,i in data
      arr[i] = d[name]
    arr

  initalize = ->
    console.log '------------'
    console.log civs
    console.log rankings
    svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + HEIGHT + ")")
    .call(xAxis);

    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)


  #load the data. runs asynchronously, so whoever finishes first calls initialize
  d3.csv 'civs.csv', (data) ->
    civdata = to_hash(data, 'name')
    civs = to_array(data, 'name')
    initalize() if (!--remaining)

  d3.csv 'rankings.csv', (data) =>
    rankings = data
    initalize() if (!--remaining)
return

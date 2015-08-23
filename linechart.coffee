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
  rankings = []
  civdata = {}
  civs = []

  to_hash = (data, name) ->
    hash = {}
    for d in data
      hash[d[name]] = d
    console.log hash
    hash

  initalize = ->
    console.log '------------'
    console.log civs




  #load the data and go
  d3.csv 'civs.csv', (data) ->
    d3.csv 'rankings.csv', (data) ->
      rankings = data
    civs = to_hash data 'name'
    initalize()
  return
return

$(document).ready ->
  MARGIN =
    TOP: 20
    RIGHT: 80
    BOTTOM: 30
    LEFT: 50
  WIDTH = 960 - (MARGIN.LEFT) - (MARGIN.RIGHT)
  HEIGHT = 500 - (MARGIN.TOP) - (MARGIN.BOTTOM)
  parseDate = d3.time.format('%Y%m%d').parse
  x = d3.scale.linear().range([
    0
    WIDTH
  ])
  y = d3.scale.linear().range([
    HEIGHT
    0
  ])
  color = d3.scale.category10()
  xAxis = d3.svg.axis().scale(x).orient('bottom')
  yAxis = d3.svg.axis().scale(y).orient('left')
  line = d3.svg.line().interpolate('basis').x((d) ->
    x d.date
  ).y((d) ->
    y d.temperature
  )
  console.log 'fuckfuckfuck'
  svg = d3.select('#linechart').append('svg').attr('width', WIDTH + MARGIN.LEFT + MARGIN.RIGHT).attr('height', HEIGHT + MARGIN.TOP + MARGIN.BOTTOM).append('g').attr('transform', 'translate(' + MARGIN.LEFT + ',' + MARGIN.TOP + ')')
return

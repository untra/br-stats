$(document).ready ->
  MARGIN =
    TOP: 20
    RIGHT: 80
    BOTTOM: 30
    LEFT: 50
  WIDTH = 1370 - (MARGIN.LEFT) - (MARGIN.RIGHT)
  HEIGHT = 750 - (MARGIN.TOP) - (MARGIN.BOTTOM)
  TURNS = 70
  UPLOADS = 3
  PLAYERS = 61
  X = d3.scale.linear()
  .range([
    0
    WIDTH
  ])
  .domain([
    0,
    TURNS
  ])
  Y = d3.scale.linear()
  .range([
    HEIGHT
    0
  ])
  .domain([
    PLAYERS
    1
  ])
  console.log "'Sup kid. Good on you for looking at the console. Doesn't say much, but it means you care. <3 untra"

  svg = d3.select('#linechart').append('svg')
  .attr('width', WIDTH + MARGIN.LEFT + MARGIN.RIGHT)
  .attr('height', HEIGHT + MARGIN.TOP + MARGIN.BOTTOM)
  .append('g').attr('transform', 'translate(' + MARGIN.LEFT + ',' + MARGIN.TOP + ')')

  rankings = {}
  civdata = {}
  civs = []
  indices = []
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

  to_numbers = (data) ->
    arr = []
    for d,i in data
      arr.push +d unless isNaN parseInt +d
    arr

  path = (d) ->
    indices.map((p) ->
      [
        X(p)
        Y(d[p])
      ]
    )

  hoverformat = (d) ->


  initalize = ->
    line = d3.svg.line()
    xAxis = d3.svg.axis().scale(X).orient('bottom').tickValues(indices).tickSubdivide(0)
    yAxis = d3.svg.axis().scale(Y).orient('left').ticks(PLAYERS)
    axes = svg.append("g")
      .attr("class", "axes")

    yaxis = axes.append("g")
      .attr("class", "axis")
      .attr("transform", "translate(0," + HEIGHT + ")")
      .call(xAxis);

    xaxis = axes.append("g")
      .attr("class", "axis")
      .call(yAxis)

    xaxis.selectAll '.tick line'
      .attr 'x2', (d) ->
        WIDTH

    yaxis.selectAll '.tick line'
      .attr 'y1', 0
      .attr 'y2', -HEIGHT

    civlines = svg.selectAll '.civlines'
      .data rankings
      .enter().append('g')

    civlines.append('path')
      .attr 'class', 'line'
      .attr 'd', (d) ->
        line path d
      .style 'stroke', (d) ->
        civdata[d.name].primary

    circles = civlines.selectAll('circle')
      .data rankings
      .enter().append 'g'

    for i in indices
      circles.append 'circle'
        .attr 'cx', (d) ->
          X(i)
        .attr 'cy', (d) ->
          Y(d[i])
        .attr 'r', 4
        .style 'fill', (d) ->
          civdata[d.name].secondary
        .style 'stroke', (d) ->
          civdata[d.name].primary
        .on('mouseover', (d) ->
          x = +(d3.select(this).attr 'cx')
          y = +(d3.select(this).attr 'cy')
          d3.select(this.parentNode).append 'text'
          .attr 'x', x + 10
          .attr 'y', y + 4
          .text d.name
          return
        ).on 'mouseout', (d) ->
          selection = d3.select(this.parentNode).selectAll('text').remove()
          return

  #load the data. runs asynchronously, so whoever finishes first calls initialize
  d3.csv 'civs.csv', (data) ->
    civdata = to_hash(data, 'name')
    civs = to_array(data, 'name')
    initalize() if (!--remaining)

  d3.csv 'rankings.csv', (data) =>
    rankings = data
    indices = to_numbers Object.keys data[0]
    initalize() if (!--remaining)
return

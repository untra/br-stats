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
  toggle = null
  civlines = null

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

  hoverformat = (d, i) ->
    "\##{d[i]} #{d.name}"

  change = (d) ->
    checked = toggle.select("[name=#{d.name}]").property 'checked'
    value = if checked then null else 'hidden'
    lines = civlines.filter (p) ->
      p.name == d.name
    lines.style 'visibility', value

  initalize = ->
    X.domain([
        0,
        TURNS
      ])
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

    # extend the axes
    xaxis.selectAll '.tick line'
      .attr 'x2', (d) ->
        WIDTH

    yaxis.selectAll '.tick line'
      .attr 'y1', 0
      .attr 'y2', -HEIGHT

    civlines = svg.append 'g'
      .attr 'class', 'civlines'
      .selectAll 'g'
      .data rankings
      .enter().append 'g'
      .attr 'name', (d) ->
        d.name

    civlines.append('path')
      .attr 'class', 'line'
      .attr 'd', (d) ->
        line path d
      .style 'stroke', (d) ->
        civdata[d.name].primary

    for i in indices
      civlines.append 'circle'
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
          .text hoverformat d, i
          return
        ).on 'mouseout', (d) ->
          selection = d3.select(this.parentNode).selectAll('text').remove()
          return

    toggle.append 'input'
    .attr 'type', 'checkbox'
    .property 'checked', true
    .attr 'name', (d) ->
      d.name
    .on 'change', (d) ->
      change d

    toggle.append 'img'
    .attr 'src', (d) ->
      d.flair
    .attr 'title', (d) ->
      d.name
    .attr 'width', 32
    .attr 'height',32


  #load the data. Runs asynchronously, so whoever finishes first calls initialize
  d3.csv 'civs.csv', (data) ->
    toggle = d3.select('#civtoggle')
      .selectAll 'label'
      .data data
      .enter().append 'label'
    civdata = to_hash(data, 'name')
    civs = to_array(data, 'name')
    initalize() if (!--remaining)

  d3.csv 'rankings.csv', (data) =>
    rankings = data
    indices = to_numbers Object.keys data[0]
    TURNS = d3.max indices
    initalize() if (!--remaining)
return

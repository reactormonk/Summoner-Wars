e = exports
_ = require('underscore')
exports.point =
  union: (ary) ->
    # this kind of sux, but we're not really using arrays, so
    set = []
    for pos in ary
      if not _.any(set, pos.eq.bind(pos))
        set.push(pos)
    set
  create: (ary,y) ->
    point = Object.create(this)
    if y?
      point.x = ary
      point.y = y
    else
      point.x = ary[0]
      point.y = ary[1]
    point
  combine: (other) -> e.point.create(@x + other.x, @y + other.y)
  eq: (other) -> @x is other.x and @y is other.y
  ary: -> [@x, @y] # mostly for testing

exports.card =
  create: -> Object.create(this)
  moveRange: 2
  directions: _.map([[0,1], [1,0], [-1, 0], [0,-1]], (element) -> e.point.create(element))
  aryPos: (ary) ->
    if ary?
      @position = e.point.create(ary)
    else
      @position.ary
  mayMove: ->
    e.point.union @_mayMove(@position, @moveRange)
  _mayMove: (position, moveRange) ->
    return [position] if moveRange is 0
    res = for direction in @directions
      @_mayMove(position.combine(direction), moveRange - 1)
    res = _.flatten(res, true)
    res.push(position)
    set = e.point.union(res)
    debugger
    _.filter(set, @mayMoveTo.bind(this))
  mayMoveToAnd: []
  mayMoveTo: (position) ->
    for fun in @mayMoveToAnd
      return false unless fun.call(this, position)
    true

exports.field =
  content: []
  addObject: (card) -> content.push(card)
  removeObject: (card) ->
exports.card.mayMoveToAnd.push (position) ->
  not @position.eq(position)
exports.card.mayMoveToAnd.push (position) ->
  position.x >= 0 and position.y >= 0

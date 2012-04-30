logic = require('../src/logic')
util = require('util')
_ = require('underscore')
expect = require('expect.js')
comparePos = (positions, output) ->
  ary = _.map(positions, (point) -> point.ary())
  expect(ary.sort()).to.be.eql(output.sort())

describe "combine", ->
  it "combines positions", ->
    for combination in [
      [[0,0], [1,1], [1,1]],
      [[2,2], [1,2], [3,4]],
      [[3,6], [-2,-5], [1,1]],
      [[0,0], [-1,1], [-1,1]]
    ]
      [posA, posB, result] = combination
      expect(logic.point.create(posA).combine(logic.point.create(posB)).ary()).to.be.eql(result)
  it "equal positions", ->
    for combination in [
      [[1,1], [1,1], true],
      [[2,2], [1,2], false],
      [[3,6], [-2,-5], false],
      [[-1,1], [-1,1], true]
    ]
      [posA, posB, result] = combination
      expect(logic.point.create(posA).eq(logic.point.create(posB))).to.be.eql(result)
  it "union", ->
    for combination in [
      [[[1,1], [1,1]], [[1,1]]],
      [[[2,2], [1,2]], [[2,2], [1,2]]],
      [[[3,6], [-2,-5], [3,6]], [[3,6], [-2,-5]]]
    ]
      [ary, result] = combination
      comparePos(logic.point.union(_.map(ary, (ele) -> logic.point.create(ele))), result)
  describe "mayMove", ->
    it "works with move 0", ->
      card = logic.card.create()
      card.moveRange = 0
      card.aryPos([0,0])
      comparePos(card.mayMove(), [[0,0]])
    it "works with move 1", ->
      card = logic.card.create()
      card.moveRange = 1
      card.aryPos([1,1])
      comparePos(card.mayMove(), [[1,2], [2,1], [0,1], [1,0]].sort())
    for combination in [{
      position: [0,0],
      output: [[1,0], [0,1], [2,0], [0,2], [1,1]]
    }, {
      position: [2,2],
      output: [[2,1], [2,0], [1,2], [0,2], [2,3], [2,4], [3,2], [4,2], [1,1], [3,3], [1,3], [3,1]]
    }]
      ((combination) ->
        it "gives possible move positions", ->
          card = logic.card.create()
          card.aryPos(combination.position)
          comparePos(card.mayMove(), combination.output)
      )(combination)

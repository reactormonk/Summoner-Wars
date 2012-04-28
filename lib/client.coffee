SW = Ember.Application.create()
SW.views = {}
SW.min = (x,y) ->
        if x < y
                x
        else
                y

SW.card = Ember.Object.extend
        health: 1
        range: 1
        power: 1
        abilites: []
        side: null
        sectionLeave: (->
                name = @get('section')
                section = SW[name]
                console.log('unknown section ' + name) if name? and not section?
                section? and section.removeObject(this)
        ).observesBefore('section')
        sectionEnter: (->
                SW[@get('section')].addObject(this)
        ).observes('section')

SW.views.card = Ember.View.extend
        img: -> @$().find('img')
        templateName: 'card'
        alt: (->
                @getPath('content.name') + " of the " + @getPath('content.fraction')
        ).property('content.fraction', 'content.name')
        src: (->
                escape if @getPath('content.name')? or @getPath('content.flipped')
                        "./images/" + @getPath('content.fraction') + '-' + @getPath('content.name') + '.jpg'
                else
                        "./images/Cardback-" + @getPath('content.fraction') + '.jpg'
        ).property('content.fraction', 'content.name', 'content.flipped')

SW.views.field = SW.views.card.extend
        positionTemplate: Handlebars.compile("td[data-posX={{posX}}][data-posY={{posY}}]")
        positionChanged: (->
                [posX, posY] = @getPath('content.position')
                # TODO collectionView should work
                target = @$().parents('.battlefield').find @positionTemplate
                        posX: posX
                        posY: posY
                target.append(@$())
                $.fn.hoverzoom(@img())
        ).observes('content.position')
        sideChanged: (->
                if classes = @img().attr('class')
                        othersides = (attr for attr in classes when /^side\d/.test(attr))
                @img().removeClass othersides
                @img().addClass('side' + @getPath('content.side'))
        ).observes('content.side')
        didInsertElement: ->
                @positionChanged()
                @sideChanged()

SW.views.hand = SW.views.card.extend()

SW.field = Ember.CollectionView.create
        size: [6, 8] # 6 -> 8 ^
        content: []
        classNames: ['battlefield']
        tagName: 'div'
        itemViewClass: SW.views.field
        width: -> @$().width() # or $(window).width() when resizing?
        addObject: (card) -> @content.addObject(card)
        removeObject: (card) -> @content.removeObject(card)
        resize: ->
                height = 20 # should be low enough
                tds = @$().find('td')
                for td in tds # max algorithm
                        h = $(td).height()
                        h > height and height = h
                if height is 20 # let's try again later
                        setTimeout(@resize.bind(this), 50)
                else # will flicker, but shouldn't happen that often
                        for td in tds
                                $(td).css('height', height)
        didInsertElement: ->
                template = Handlebars.compile($("#field-template").html())
                [sizeX, sizeY] = @size
                content = for y in [(sizeY-1)..0]
                        for x in [0..(sizeX-1)]
                                posX: x
                                posY: y
                @$().append template(content)

SW.proto = {}
SW.proto.hand = Ember.CollectionView.extend
        itemViewClass: SW.views.hand
        addObject: (card) -> @content.addObject(card)
        removeObject: (card) -> @content.removeObject(card)
        tagName: 'ul'

SW.hand = Ember.Object.create()
SW.hand.yours = SW.proto.hand.create
        classNames: ['yours', 'hand']
        side: 0
        content: []
SW.hand.enemy = SW.proto.hand.create
        classNames: ['enemy', 'hand']
        side: 1
        content: []

SW.hand.reopen
        sideToHand: [SW.hand.yours, SW.hand.enemy]
        eachHand: (fn) ->
                for hand in @sideToHand
                        fn.call(hand)
        addObject: (card) -> @sideToHand[card.side]?.addObject(card)
        removeObject: (card) -> @eachHand -> @removeObject(card)
        sideChanged: ((changed) ->
                @removeObject(changed)
                @addObject(changed)
        ).observes('yours.content.@each.side', 'enemy.content.@each.side')

$(-> SW.field.appendTo('#container'))
$(-> SW.hand.yours.appendTo('#container'))
$(window).resize(SW.field.resize.bind(SW.field))
$(SW.field.resize.bind(SW.field))

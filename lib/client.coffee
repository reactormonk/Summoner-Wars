Ember.View.states.inDOM.insertElement = (view, fn) ->
        fn.call(view)

SW = Ember.Application.create
SW.views = {}
SW.card = Ember.Object.extend
        health: 1
        range: 1
        power: 1
        abilites: []
        side: null
        init: ->
                SW.views.card.create({content: this})

SW.views.card = Ember.View.extend
        classNames: ['card']
        tagName: 'img'
        attributeBindings: ['src', 'alt']
        alt: (->
                @getPath('content.name') + " of the " + @getPath('content.fraction')
        ).property('content.fraction', 'content.name')
        src: (->
                escape if @getPath('content.name')?
                        "./images/" + @getPath('content.fraction') + '-' + @getPath('content.name') + '.jpg'
                else
                        "./images/Cardback-" + @getPath('content.fraction') + '.jpg'
        ).property('content.fraction', 'content.name')
        magnifyBindings: (->
                content = @content
                @$().unbind('mouseenter')
                @$().mouseenter ->
                        SW.magnifier.set('content', content)
        ).observes('content')
        didInsertElement: ->
                @updateSide()
                @magnifyBindings()

(->
        for attribute in ['position', 'side', 'section']
                (->
                        name = 'update' + (attribute[0].toUpperCase() + attribute[1..])
                        obj = {}
                        obj[name] = (->
                                SW.views.card.state[@getPath('content.section')][name]?.call(this)
                        ).observes('content.' + attribute)
                        SW.views.card.reopen(obj)
                )()
)()

SW.views.card.state = {}
SW.views.card.state.field =
        updatePosition: ->
                [posX, posY] = @getPath('content.position')
                @appendTo $("#field td[data-posX=" + posX + "][data-posY=" + posY + "]")
                @updateSide
        updateSide: ->
                if this.state is 'inDOM'
                        othersides = (attr for attr in @$().attr('class') when /^side\d/.test(attr))
                        @$().removeClass othersides
                        @$().addClass('side' + @getPath('content.side'))


SW.views.card.state.hand =
        updateSide: ->
                @appendTo $('.hand[data-side=' + @getPath('content.side') + ']')
        updateSection: ->
                @updateSide()

SW.magnifier = SW.views.card.create
        magnifiyBindings: ->
        updateSide: ->
        updateMagnified: (->
                @appendTo('#magnified')
        ).observes('content')

$ -> # generate the field
        template = Handlebars.compile($("#field-template").html())
        content = for x in [0..5]
                for y in [0..5]
                        posX: x
                        posY: y
        $('#field').append template(content)
        true

$ -> # generate the hands
        sides = for side in [0..1] # probably more later
                template = Handlebars.compile($('#hand-template').html())
                $('body').append template
                        side: side
                        yours: side % 2 is 0
        true


SW.resizeField = ->
        height = 10 # should be low enough
        for td in $('#field td') # max algorithm
                h = $(td).children().first().height()
                h > height and height = h
        if height is 10 # let's try again later
                setTimeout(SW.resizeField, 100)
        else
                for td in $('#field td')
                        $(td).css('height', height)

$(window).resize(SW.resizeField)
$(SW.resizeField)

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
        attributeBindings: ['src']
        src: (->
                if @getPath('content.name')?
                        "./images/" + @getPath('content.fraction') + '-' + @getPath('content.name') + '.jpg'
                else
                        "./images/Cardback-" + @getPath('content.fraction') + '.jpg'
        ).property('content.fraction', 'content.name')
        magnifyBindings: (->
                content = @content
                @$().unbind('mouseenter mouseleave')
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
                @appendTo $("#field [data-posX=" + posX + "][data-posY=" + posY + "]")
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
        for x in [0..5]
                for y in [0..5]
                        $('#field').append template
                                posX: x
                                posY: y
        true

resizeField = ->
        max = 0
        for field in $('.field')
                posX = parseInt($(field).attr('data-posx'), 10)
                if posX > max
                        max = posX
        max = max + 1
        for dom in $('.field')
                field = $(dom)
                posX = parseInt(field.attr('data-posx'), 10)
                posY = parseInt(field.attr('data-posy'), 10)
                width = $('#field').width() / max
                field.css('left', posX * width)
                field.css('top', posY * (width / 1.5))
$(window).resize(resizeField)
$(resizeField)

$ -> # generate the hands
        sides = for side in [0..1] # probably more later
                template = Handlebars.compile($('#hand-template').html())
                $('body').append template
                        side: side
                        yours: side % 2 is 0

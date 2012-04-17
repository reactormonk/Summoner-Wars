$.fn.transform = (operator)->
        this.css('-moz-transform', operator)
        this.css('-webkit-transform', operator)
        this.css('-o-transform', operator)
        this.css('-ms-transform', operator)
        this.css('transform', operator)

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
                                SW.views.card.state[@getPath('content.section')][name]?.bind(this).call()
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
                deg = (@content.get('side') % 2)*180
                @$().transform('rotate(' + deg + 'deg)')

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
                                left: 150*x # abitrary, see css
                                top: 100*y
        true

$ -> # generate the hands
        sides = for side in [0..1] # probably more later
                template = Handlebars.compile($('#hand-template').html())
                $('body').append template
                        side: side
                        yours: side % 2 is 0

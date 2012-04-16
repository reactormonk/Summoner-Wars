$.fn.transform = (operator)->
        this.css('-moz-transform', operator)
        this.css('-webkit-transform', operator)
        this.css('-o-transform', operator)
        this.css('-ms-transform', operator)
        this.css('transform', operator)

SW = Ember.Application.create
SW.views = {}
SW.card = Ember.View.extend
        position: [1,2]
        name: "Milita"
        health: 1
        fraction: "Mercenaries"
        range: 1
        power: 1
        abilites: []
        side: null
        # add something to set position in case of hand n stuff
        section: null # hand, field, magic, discard
        init: ->
                SW.views.card.create({content: this})


SW.views.card = Ember.View.extend
        classNames: ['card']
        tagName: 'img'
        attributeBindings: ['src']
        src: (->
                "./images/" + @content.get('fraction') + '-' + @content.get('name') + '.jpg'
        ).property('content.fraction', 'content.name')
        updatePosition: (->
                [position_x, position_y] = @content.get('position')
                jq = @$()
                jq.css('left', position_x*jq.width() + 'px');
                jq.css('top', position_y*jq.height() + 'px');
        ).observes('content.position')
        updateSection: (->
                @appendTo("#" + @content.get('section'))
        ).observes('content.section')
        updateSide: (->
                deg = (@content.get('side') % 2)*180
                @$().transform('rotate(' + deg + 'deg)')
        ).observes('content.side')
        magnifyBindings: (->
                content = @content
                @$().mouseenter ->
                        SW.magnifier.set('content', content)
                @$().mouseleave ->
                        SW.magnifier.clear()
        ).observes('src')
        didInsertElement: ->
                @updatePosition()
                @updateSide()
                @magnifyBindings()

SW.magnifier = SW.views.card.create
        updatePosition: ->
        updateSection: ->
        updateSide: ->
        clear: ->
                that = @$()
                @timeout = window.setTimeout((-> that.fadeOut(500)), 2000)
        updateMagnified: (->
                @exists? or @appendTo('#magnified')
                @$().fadeIn(100)
                window.clearTimeout(@timeout)
        ).observes('content')
        didInsertElement: ->
                @_super()
                @exists = true

$ ->
        c = SW.card.create()
        c.set('section', "field")
        c.set('position', [1,2])
        c.set('side', 0)
        d = SW.card.create()
        d.set('section', "field")
        d.set('position', [1,1])
        d.set('side', 1)
        d.set('name', 'Owl Familiar')
        e = SW.card.create()
        e.set('section', "field")
        e.set('position', [4,1])
        e.set('side', 1)
        e.set('name', 'Lun')
        e.set('fraction', 'Deep Dwarves')

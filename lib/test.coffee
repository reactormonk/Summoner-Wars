$ ->
        # calling convention: you first need to set all attributes a
        # section needs, then you can set the section.
        tests = []
        tests[0] = SW.card.create()
        tests[0].set('side', 1)
        tests[0].set('position', [0,0])
        tests[0].set('fraction', 'Cave Goblins')
        tests[0].set('name', 'Fighter')
        tests[0].set('section', "field")
        tests[1] = SW.card.create()
        tests[1].set('position', [5,5])
        tests[1].set('side', 0)
        tests[1].set('fraction', 'Mercenaries')
        tests[1].set('name', 'Owl Familiar')
        tests[1].set('section', "field")
        tests[2] = SW.card.create()
        tests[2].set('position', [1,0])
        tests[2].set('side', 0)
        tests[2].set('fraction', 'Deep Dwarves')
        tests[2].set('name', 'Lun')
        tests[2].set('section', "field")
        tests[3] = SW.card.create()
        tests[3].set('side', 0)
        tests[3].set('name', 'Scholar')
        tests[3].set('fraction', 'Deep Dwarves')
        tests[3].set('section', "hand")
        tests[4] = SW.card.create()
        tests[4].set('side', 0)
        tests[4].set('name', 'Miner')
        tests[4].set('fraction', 'Deep Dwarves')
        tests[4].set('section', "hand")
        tests[4].set('position', [2,7])
        tests[4].set('section', "field")
        tests[5] = SW.card.create()
        tests[5].set('side', 0)
        tests[5].set('position', [5,7])
        tests[5].set('name', 'Scholar')
        tests[5].set('fraction', 'Deep Dwarves')
        tests[5].set('section', "field")
        setTimeout (-> tests[5].set('position', [5,5])), 2000
        tests[6] = SW.card.create()
        tests[6].set('side', 0)
        tests[6].set('name', 'Gem Mage')
        tests[6].set('fraction', 'Deep Dwarves')
        tests[6].set('section', "hand")
        tests[7] = SW.card.create()
        tests[7].set('side', 0)
        tests[7].set('name', 'Gem Mage')
        tests[7].set('fraction', 'Deep Dwarves')
        tests[7].set('section', "hand")
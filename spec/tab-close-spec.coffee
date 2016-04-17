$ = require 'jquery'

describe 'Tab Close', ->
  [firstTab, shiftClick, ctrlClick, altClick] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)

    waitsForPromise ->
      atom.packages.activatePackage 'tab-close'
    waitsForPromise ->
      atom.packages.activatePackage 'tabs'
    waitsForPromise ->
      atom.workspace.open 'sample.txt'

    runs ->
      firstTab = $('.tab-bar .tab:first')

      shiftClick = $.Event("click")
      shiftClick.shiftKey = true
      ctrlClick = $.Event("click")
      ctrlClick.ctrlKey = true
      altClick = $.Event("click")
      altClick.altKey = true

  describe 'when action is set to double-click', ->
    beforeEach ->
      atom.config.set('tab-close.closeMethod', 'double-click')

    it 'closes a tab when it is double-clicked', ->
      firstTab.dblclick()
      expect($('.tab-bar .tab')).toHaveLength(0)

    it 'closes only a clicked tab', ->
      waitsForPromise ->
        atom.workspace.open 'sample2.txt'
      runs ->
        expect($('.tab-bar .tab')).toHaveLength(2)
        firstTab.dblclick()
        expect($('.tab-bar .tab')).toHaveLength(1)
        expect($('.tab-bar .tab:first').text()).toEqual('sample2.txt')

    it 'does not close a with other actions', ->
      firstTab.trigger(shiftClick)
      expect($('.tab-bar .tab')).toHaveLength(1)
      firstTab.trigger(ctrlClick)
      expect($('.tab-bar .tab')).toHaveLength(1)
      firstTab.trigger(altClick)
      expect($('.tab-bar .tab')).toHaveLength(1)

  describe 'when action is set to shift + single-click', ->
    beforeEach ->
      atom.config.set('tab-close.closeMethod', 'shift + single-click')

    it 'closes a tab with this action', ->
      atom.config.set('tab-close.closeMethod', 'shift + single-click')
      firstTab.trigger(shiftClick)
      expect($('.tab-bar .tab')).toHaveLength(0)

    it 'does not close a tab when it is single-clicked', ->
      firstTab.click()
      expect($('.tab-bar .tab')).toHaveLength(1)

  describe 'when action is set to ctrl + single-click', ->
    it 'closes a tab with this action', ->
      atom.config.set('tab-close.closeMethod', 'ctrl + single-click')
      firstTab.trigger(ctrlClick)
      expect($('.tab-bar .tab')).toHaveLength(0)

  describe 'when action is set to alt + single-click', ->
    it 'closes a tab with this action', ->
      atom.config.set('tab-close.closeMethod', 'alt + single-click')
      firstTab.trigger(altClick)
      expect($('.tab-bar .tab')).toHaveLength(0)

  describe '::deactivate', ->
    it 'removes a listener from tabs', ->
      atom.packages.deactivatePackage('tab-close')
      expect(atom.config.get('tab-close.closeMethod')).toEqual('double-click')
      firstTab.dblclick()
      expect($('.tab-bar .tab')).toHaveLength(1)

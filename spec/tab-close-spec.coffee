$ = require 'jquery'

describe 'Tab Close', ->
  [tabFirst, shiftClick, ctrlClick, altClick] = []

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
      tabFirst = $('.tab-bar .tab:first')

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
      tabFirst.dblclick()
      expect($('.tab-bar .tab')).toHaveLength(0)

    it 'closes only a clicked tab', ->

    it 'does not close a with other actions', ->
      tabFirst.trigger(shiftClick)
      expect($('.tab-bar .tab')).toHaveLength(1)
      tabFirst.trigger(ctrlClick)
      expect($('.tab-bar .tab')).toHaveLength(1)
      tabFirst.trigger(altClick)
      expect($('.tab-bar .tab')).toHaveLength(1)

  describe 'when action is set to shift + single-click', ->
    beforeEach ->
      atom.config.set('tab-close.closeMethod', 'shift + single-click')

    it 'closes a tab with this action', ->
      atom.config.set('tab-close.closeMethod', 'shift + single-click')
      tabFirst.trigger(shiftClick)
      expect($('.tab-bar .tab')).toHaveLength(0)

    it 'does not close a tab when it is single-clicked', ->
      tabFirst.click()
      expect($('.tab-bar .tab')).toHaveLength(1)

  describe 'when action is set to ctrl + single-click', ->
    it 'closes a tab with this action', ->
      atom.config.set('tab-close.closeMethod', 'ctrl + single-click')
      tabFirst.trigger(ctrlClick)
      expect($('.tab-bar .tab')).toHaveLength(0)

  describe 'when action is set to alt + single-click', ->
    it 'closes a tab with this action', ->
      atom.config.set('tab-close.closeMethod', 'alt + single-click')
      tabFirst.trigger(altClick)
      expect($('.tab-bar .tab')).toHaveLength(0)

  describe '::deactivate', ->
    it 'removes a listener from tabs', ->
      atom.packages.deactivatePackage('tab-close')
      expect(atom.config.get('tab-close.closeMethod')).toEqual('double-click')
      tabFirst.dblclick()
      expect($('.tab-bar .tab')).toHaveLength(1)

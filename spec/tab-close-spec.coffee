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
      firstTab = $('.pane .tab:first')

      shiftClick = $.Event("click")
      shiftClick.shiftKey = true
      ctrlClick = $.Event("click")
      ctrlClick.ctrlKey = true
      altClick = $.Event("click")
      altClick.altKey = true

  expectTabsCount = (length) ->
    expect($('.pane .tab')).toHaveLength(length)

  describe 'when action is set to double-click', ->
    beforeEach ->
      atom.config.set('tab-close.closeMethod', 'double-click')

    it 'closes a tab when it is double-clicked', ->
      firstTab.dblclick()
      expectTabsCount(0)

    it 'closes only a clicked tab', ->
      waitsForPromise ->
        atom.workspace.open 'sample2.txt'
      runs ->
        expectTabsCount(2)
        firstTab.dblclick()
        expectTabsCount(1)
        expect($('.tab-bar .tab:first').text()).toEqual('sample2.txt')

    it 'closes a tab on the second pane', ->
      waitsForPromise ->
        atom.workspace.open 'sample2.txt', split: 'right'
      runs ->
        expectTabsCount(2)
        firstTab.dblclick()
        expectTabsCount(1)
        expect($('.tab-bar .tab:first').text()).toEqual('sample2.txt')

    it 'does not close a tab with other actions', ->
      firstTab.trigger(shiftClick)
      expectTabsCount(1)
      firstTab.trigger(ctrlClick)
      expectTabsCount(1)
      firstTab.trigger(altClick)
      expectTabsCount(1)

  describe 'when action is set to shift + single-click', ->
    beforeEach ->
      atom.config.set('tab-close.closeMethod', 'shift + single-click')

    it 'closes a tab with this action', ->
      atom.config.set('tab-close.closeMethod', 'shift + single-click')
      firstTab.trigger(shiftClick)
      expectTabsCount(0)

    it 'does not close a tab when it is single-clicked', ->
      firstTab.click()
      expectTabsCount(1)

  describe 'when action is set to ctrl + single-click', ->
    it 'closes a tab with this action', ->
      atom.config.set('tab-close.closeMethod', 'ctrl + single-click')
      firstTab.trigger(ctrlClick)
      expectTabsCount(0)

  describe 'when action is set to alt + single-click', ->
    it 'closes a tab with this action', ->
      atom.config.set('tab-close.closeMethod', 'alt + single-click')
      firstTab.trigger(altClick)
      expectTabsCount(0)

  describe 'when the configuration changes', ->
    it 'changes the close action', ->
      atom.config.set('tab-close.closeMethod', 'double-click')
      atom.config.set('tab-close.closeMethod', 'alt + single-click')
      firstTab.trigger(altClick)
      expectTabsCount(0)

  describe '::deactivate', ->
    it 'removes a listener from tabs', ->
      atom.packages.deactivatePackage('tab-close')
      expect(atom.config.get('tab-close.closeMethod')).toEqual('double-click')
      firstTab.dblclick()
      expectTabsCount(1)

$ = require 'jquery'

module.exports =
  config:
    closeMethod:
      title: 'Close method'
      type: 'string'
      default: 'double-click'
      enum: [
        'double-click'
        'shift + single-click'
        'ctrl + single-click'
        'alt + single-click'
      ]

  activate: ->
    atom.config.observe 'tab-close-double-click.closeMethod', (closeMethod) =>
      @setCloseMethod closeMethod

  setCloseMethod: (closeMethod) ->
    @turnOffLastCloseMethod()
    @turnOnCloseMethod(closeMethod)

  turnOffLastCloseMethod: ->
    $('.panes').off @mouseAction, '.tab', @closeFunction

  turnOnCloseMethod: (closeMethod) ->
    [@mouseAction, modifierKey] = @actionForCloseMethod closeMethod
    @closeFunction = @createCloseFunction modifierKey
    $('.panes').on @mouseAction, '.tab', @closeFunction

  actionForCloseMethod: (closeMethod) ->
    switch closeMethod
      when 'double-click' then ['dblclick', null]
      when 'shift + single-click' then ['click', 'shift']
      when 'ctrl + single-click' then ['click', 'ctrl']
      when 'alt + single-click' then ['click', 'alt']

  createCloseFunction: (modifierKey) ->
    (keyPressed) ->
      return if modifierKey is 'shift' and not keyPressed.shiftKey
      return if modifierKey is 'ctrl' and not keyPressed.ctrlKey
      return if modifierKey is 'alt' and not keyPressed.altKey
      tabIndex = $('.tab').index($(this))
      itemToDestroy = atom.workspace.getPaneItems()[tabIndex]
      clickedPane = atom.workspace.paneForItem(itemToDestroy)
      clickedPane.destroyItem(itemToDestroy)

$ = require 'jquery'

CloseMethods = Object.freeze(
  DOUBLE_CLICK: 'double-click'
  SHIFT_CLICK: 'shift + single-click'
  CTRL_CLICK: 'ctrl + single-click'
  ALT_CLICK: 'alt + single-click'
)

module.exports =
  config:
    closeMethod:
      title: 'Close method'
      type: 'string'
      default: CloseMethods.DOUBLE_CLICK
      enum: [
        CloseMethods.DOUBLE_CLICK
        CloseMethods.SHIFT_CLICK
        CloseMethods.CTRL_CLICK
        CloseMethods.ALT_CLICK
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
      when CloseMethods.DOUBLE_CLICK then ['dblclick', null]
      when CloseMethods.SHIFT_CLICK then ['click', 'shift']
      when CloseMethods.CTRL_CLICK then ['click', 'ctrl']
      when CloseMethods.ALT_CLICK then ['click', 'alt']

  createCloseFunction: (modifierKey) ->
    (keyPressed) ->
      return if modifierKey is 'shift' and not keyPressed.shiftKey
      return if modifierKey is 'ctrl' and not keyPressed.ctrlKey
      return if modifierKey is 'alt' and not keyPressed.altKey
      tabIndex = $('.tab').index($(this))
      itemToDestroy = atom.workspace.getPaneItems()[tabIndex]
      clickedPane = atom.workspace.paneForItem(itemToDestroy)
      clickedPane?.destroyItem(itemToDestroy)

  deactivate: ->
    @turnOffLastCloseMethod()

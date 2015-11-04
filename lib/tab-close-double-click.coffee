$ = require('jquery')

module.exports =
  activate: ->
    $(".panes").on "dblclick", ".tab", ->
      tabIndex = $(".tab").index($(this))
      itemToDestroy = atom.workspace.getPaneItems()[tabIndex]
      clickedPane = atom.workspace.paneForItem(itemToDestroy)
      clickedPane.destroyItem(itemToDestroy)

{SelectListView} = require 'atom-space-pen-views'

module.exports =
class BaseSelectListView extends SelectListView
  panelClass: null

  initialize: ({@callback, @panelClass}) ->
    super
    @addClass('with-action')

  cancel: ->
    lastSearch = @getFilterQuery()
    super

    @filterEditorView.setText(lastSearch)
    @filterEditorView.getModel().selectAll()

  destroy: ->
    @cancel()
    @panel?.destroy()

  confirmed: (item) ->
    @callback(item)
    @cancel()

  show: (populate = true)->
    if populate
      @filterEditorView.setText('')
      @populate?()

    @panel ?= atom.workspace.addModalPanel(item: this, className: @panelClass)
    @panel.show()
    @focusFilterEditor()

  hide: ->
    @panel?.hide()

  isShow: ->
    !!@panel?.isVisible()

  toggle: ->
    if @isShow()
      @cancel()
    else
      @show()

  cancelled: ->
    @hide()

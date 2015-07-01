{$} = require 'atom-space-pen-views'
_ = require 'underscore-plus'
SelectItemsView = require './select-items-view'
SelectActionsView = require './select-actions-view'

module.exports =
class ActionSelectListView
  selectedItem: null
  toggling: false
  panelClass: null

  constructor: ({actions, items, filterKey}) ->
    @setActions(actions)

    @views = new Map()
    @views.set('items', new SelectItemsView({items, filterKey, @contentForItem, @panelClass, callback: @defaultAction}))
    @views.set('actions', new SelectActionsView({@actions, @panelClass, callback: @selectedAction}))

    @views.forEach((view) =>
      view.restoreFocus = @restoreFocus
      atom.commands.add(view.element, 'select-list:select-action', @toggleView)
    )

  destroy: ->
    @views.forEach((view) ->
      view.destroy()
    )
    @views.clear()

  contentForItem: (item, filterQuery, filterKey) ->
    throw new Error("Subclass must implement a contentForItem(item, filterQuery) method")

  setActions: (actions) ->
    if _.isFunction(actions)
      actions = [{callback: actions}]
    @actions = actions

  toggle: ->
    if @isShow()
      @hide()
    else
      @show()

  isShow: ->
    isShow = false
    @views.forEach((view) ->
      isShow = true if view.isShow()
    )
    isShow

  show: ->
    @storeFocusedElement()
    @views.get('items').show()

  hide: ->
    @views.forEach((view) ->
      view.hide()
    )

  defaultAction: (item) =>
    @actions[0].callback(item)

  selectedAction: (action) =>
    return unless @selectedItem
    action.callback(@selectedItem)

  toggleView: =>
    return if @actions.length < 2
    @toggling = true

    if @views.get('items').isShow()
      @selectedItem = @views.get('items').getSelectedItem()
      if @selectedItem?
        @views.get('actions').show(false)
    else
      @views.get('items').show(false)

    @toggling = false

  storeFocusedElement: ->
    @previouslyFocusedElement = $(document.activeElement)

  restoreFocus: =>
    return if @toggling
    @previouslyFocusedElement?.focus()

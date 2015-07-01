{$$} = require 'atom-space-pen-views'
BaseSelectListView = require './base-select-list-view'

module.exports =
class SelectActionsView extends BaseSelectListView
  initialize: ({actions}) ->
    super
    @setItems(actions)

  getFilterKey: ->
    'name'

  viewForItem: (item) ->
    $$ ->
      @li item.name

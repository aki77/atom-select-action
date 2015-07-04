{$$} = require 'atom-space-pen-views'
_ = require 'underscore-plus'
BaseSelectListView = require './base-select-list-view'

module.exports =
class SelectItemsView extends BaseSelectListView
  searchIndexKeys: []

  initialize: ({items, @filterKey, @contentForItem}) ->
    super
    @_items = items

    if _.isArray(@filterKey)
      @searchIndexKeys = @filterKey.slice()
      @filterKey = "_#{@filterKey.join('_')}"

  getFilterKey: ->
    @filterKey

  setItems: (items=[]) ->
    if @searchIndexKeys.length > 0
      filterKey = @getFilterKey()
      for item in items
        item[filterKey] = @searchIndexKeys.map((key) -> item[key]).join('')

    super(items)

  viewForItem: (item) ->
    fn = @contentForItem(item, @getFilterQuery(), @getFilterKey())

    $$ ->
      highlighter = (text, matches, offsetIndex) =>
        lastIndex = 0
        matchedChars = [] # Build up a set of matched chars to be more semantic

        for matchIndex in matches
          matchIndex -= offsetIndex
          continue if matchIndex < 0 # If marking up the basename, omit text matches
          unmatched = text.substring(lastIndex, matchIndex)
          if unmatched
            @span matchedChars.join(''), class: 'character-match' if matchedChars.length
            matchedChars = []
            @text unmatched
          matchedChars.push(text[matchIndex])
          lastIndex = matchIndex + 1

        @span matchedChars.join(''), class: 'character-match' if matchedChars.length

        # Remaining characters are plain text
        @text text.substring(lastIndex)

      fn.call(this, {highlighter})

  populate: ->
    items = _.result(this, '_items')
    return @setItems(items) if _.isArray(items)

    delete @items
    @list.empty()
    @setLoading("Loading\u2026")
    items.then((result) =>
      @setItems(result)
    )

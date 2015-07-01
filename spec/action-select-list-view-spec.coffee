{$, $$}  = require 'atom-space-pen-views'
ActionSelectListView = require '../src/action-select-list-view'

class TestView extends ActionSelectListView

  contentForItem: (item, filterQuery, filterKey) ->
    ->
      @li item.content

describe 'ActionSelectListView', ->
  [view, result, itemsFilterEditorView, actionsFilterEditorView] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)

    options =
      items: [
        {
          name: 'a'
          content: 'aaa'
        }
        {
          name: 'b'
          content: 'bbb'
        }
        {
          name: 'c'
          content: 'ccc'
        }
      ]
      actions: [
        {
          name: 'insert'
          callback: (item) -> result = "insert #{item.content}"
        }
        {
          name: 'remove'
          callback: (item) -> result = "remove #{item.content}"
        }
      ]
      filterKey: 'name'
    view = new TestView(options)

  describe "show", ->
    it "contentForItem", ->
      {list} = view.views.get('items')
      view.toggle()
      expect(list.find('li').length).toBe(3)
      expect(list.find('li:eq(0)')).toHaveText('aaa')

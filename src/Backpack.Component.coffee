class Backpack.Component extends Backbone.View

  tagName: 'div'
  className: 'backpack-component'

  defaults:
    'parent':     'body'
    'type':       'component'
    'renderType': 'append'
    'content': null
    'visible': true

  initialize: ->
    @_items    = []
    @_rendered = false
    @_renderTypes = ['append', 'prepend', 'html']
    @options   = _.extend({}, @defaults, @config, @options)
    for func, args of @options
      if @[func]?
        unless _.isArray(args)
          @[func].call?(@, args)
        else
          @[func].apply?(@, args)
      null

  render: =>
    func = @$parent[@_renderType]
    func.call(@$parent, @getRenderEl())
    @_rendered = true
    @

  renderType: (type) =>
    hasType = _.include(@_renderTypes, type)
    return @ unless hasType
    @_renderType = type
    @

  renderEl: (el) =>
    @_renderEl = el
    @

  getRenderEl: =>
    return @_renderEl if @_renderEl?
    return @el

  type: (type) =>
    @_type = @slug("#{Backpack.Prefix} #{type}")
    @addClass(@_type)
    @

  getType: =>
    return @_type

  visible: (show) =>
    if show
      @show()
    else 
      @hide()
    @

  show: =>
    @render() unless @isRendered()
    @delegateEvents(@events)
    @$el.removeClass('hide')
    @_visible = true
    @

  hide: =>
    @$el.addClass('hide')
    @undelegateEvents()
    @_visible = false
    @

  close: =>
    @hide()
    @remove()
    @

  remove: =>
    @undelegateEvents()
    super()
    @

  before: (content) =>
    content = @setContent(content)
    @$el.before(content)
    @
  
  after: (content) =>
    content = @setContent(content)
    @$el.after(content)
    @

  append: (content) =>
    content = @setContent(content)
    @$el.append(content)
    @

  prepend: (content) =>
    content = @setContent(content)
    @$el.prepend(content)
    @

  content: (content) =>
    return @ unless content?
    @_content = @setContent(content)
    wrappedContent = @make('div', {class: 'content clearfix'}, @_content)
    @$el.append(wrappedContent)
    @

  parent: (parent) =>
    return @ unless parent?
    @$parent = $(parent)
    @

  addClass: (klass) =>
    @$el.addClass(klass)
    @
  
  removeClass: (klass) =>
    @$el.removeClass(klass)
    @

  css: (css) =>
    @$el.css(css)
    @

  name: (name) =>
    @name = @addClass(@slug(name))
    @

  items: =>
    for item in arguments
      @_items.push(item)
    @

  getItems: =>
    return @_items

  isRendered: =>
    @_rendered

  layout: (layout) =>
    @_layout = layout
    @

  hasLayout: =>
    !!@_layout

  getLayout: =>
    return @_layout

  setContent: (content) =>
    return @ unless content?
    if content.el?
      if content.render?
        content = content.render().el
      else
        content = content.el
    else
      content = content

  slug: (string) =>
    return @ unless string?
    string
      .toLowerCase()
      .replace(/\ +/g, "-")
      .replace(/[^a-z0-9-]/g, "")
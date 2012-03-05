# class Formstrap
# 
#   @form_for: (object, options = {}, callback) ->
#     options = {} unless options?
#     builder = new Formstrap.ObjectBuilder(object, options)
#     callback(builder)
#     builder.to_html()
# 
#   @form: (options = {}, callback) ->
#     options = {} unless options?
#     builder = new Formstrap.Builder(options)
#     callback(builder)
#     builder.to_html()
# 
# class Formstrap.Helpers
# 
#   @objectToAttrs: (object) ->
#     ("#{key}='#{value}'" for key, value of object).join(" ")
# 
# class Formstrap.Builder
# 
#   constructor: (@options = {}) ->
#     @tag = @options.tag || "form"
#     delete @options.tag
#     @fields = []
#     @options["method"] ||= "post"
#     @options["action"] ||= "#"
# 
#   fieldset: (options = {}, callback) ->
#     opts = options
#     opts.tag = "fieldset"
#     opts[key] = value for key, value of @options
#     fs_form = new Formstrap.Builder(opts)
#     fs_form.object = @object
#     callback(fs_form)
#     @fields.push fs_form
# 
# 
#   text: (name, options = {}) ->
#     options["name"] = name
#     field = new Formstrap.TextField(@, options)
#     @fields.push field
# 
#   textArea: (name, options = {}) ->
#     options["name"] = name
#     field = new Formstrap.TextAreaField(@, options)
#     @fields.push field
# 
#   to_html: ->
#     html = (field.to_html() for field in @fields).join(" ")
#     delete @options.as
#     "<#{@tag} #{Formstrap.Helpers.objectToAttrs(@options)}>#{html}</#{@tag}>"
# 
# class Formstrap.ObjectBuilder extends Formstrap.Builder
# 
#   constructor: (@object, @options = {}) ->
#     super(@options)
# 
#   # text: (name, options = {}) ->
#   #   options.object = @object
#   #   super(name, options)
# 
# 
# class Formstrap.Field
# 
#   constructor: (@form, @options = {}) ->
#     @object = @form.object
#     @options.input ||= {}
#     @compileValue()
#     @compileLabel()
#     @compileName()
#     @compileId()
#     @compileClasses()
#     return @
# 
#   compileValue: ->
#     @options.input.value ||= ""
#     if @object?
#       if @object.get? and @object.get(@options.name)
#         @options.input.value = @object.get(@options.name)
#       else if @object[@options.name]?
#         @options.input.value = @object[@options.name]
# 
#   compileName: ->
#     if @form.options.as?
#       @options.input.name = "#{@form.options.as}_#{@options.input.name}"
# 
#   compileId: ->
#     @options.input.id ||= @options.input.name
# 
#   compileClasses: ->
# 
#   compileLabel: ->
#     unless @options.input.label?
#       label = @options.input.name
#       words = label.split("_")
#       res = for word in words
#         word[0].toUpperCase() + word[1..word.length]
#       @options.input.label ||= res.join(" ")
# 
# 
# class Formstrap.TextField extends Formstrap.Field
# 
#   compileClasses: ->
#     classes = "input-xlarge "
#     if @options["class"]?
#       classes += @options["class"]
#     @options["class"] = classes
# 
#   to_html: ->
#     """
#     <div class='control-group'>
#       <label for="#{@options.input.id}" class="control-label">#{@options.input.label}</label>
#       <div class='input'>
#         <input type="text" #{Formstrap.Helpers.objectToAttrs(@options.input.input)}>
#       </div>
#     </div>
#     """
# 
# class Formstrap.TextAreaField extends Formstrap.Field
# 
#   to_html: ->
#     val = @options.input.value
#     delete @options.input.value
#     # "<textarea #{Formstrap.Helpers.objectToAttrs(@options)}>#{val}</textarea>"
#     """
#     <div class='control-group'>
#       <label for="#{@options.input.id}" class="control-label">#{@options.input.label}</label>
#       <textarea #{Formstrap.Helpers.objectToAttrs(@options.input.input)}>#{val}</textarea>
#     </div>
#     """

display = (html) -> 
  # html = html.replace(/\</g, "&lt;")
  console?.log html

class User
  
  constructor: (@attributes) ->
    
  get: (key) ->
    @attributes[key]
    
user = new User(first_name: "Mark", bio: "Mark is cool")

class Formstrap
  
  @form_for: (object, form_options..., callback) ->
    opts = Formstrap.Helers.extractOptions(form_options)
    opts.object = object
    @form(opts, callback)
    
  @form: (form_options..., callback) ->
    form = new Formstrap.FormBuilder(Formstrap.Helers.extractOptions(form_options))
    callback(form)
    return form.to_html()
    
class Formstrap.Helers
  
  @extractOptions: (argument) ->
    opts = {}
    if argument? 
      if argument is []
        opts = {}
      else if argument.length >= 1
        opts = argument[0]
    return opts
    
  @objectToAttrs: (object) ->
    ("#{key}=\"#{value.replace(/\"/g, "\\\"")}\"" for key, value of object).join(" ")

  @content_tag: (tag_type, tag_attributes = {}, callback_or_content = '') ->
    if arguments.length is 2 and typeof arguments[1] is 'function' or typeof arguments[1] is 'string'
      callback_or_content = arguments[1]
      tag_attributes = {}
    callback_or_content = callback_or_content() if typeof callback_or_content is 'function'
    "<#{tag_type} #{Formstrap.Helers.objectToAttrs(tag_attributes)}>#{callback_or_content}</#{tag_type}>"

# display Formstrap.Helers.content_tag("div")
# display Formstrap.Helers.content_tag("div", {class: "pickles", id: 'my_div'})
# display Formstrap.Helers.content_tag("div", "my content")
# display Formstrap.Helers.content_tag("div", {class: "pickles", id: 'my_div'}, "my content")
# display Formstrap.Helers.content_tag "div", -> "this is my content"
# display Formstrap.Helers.content_tag "div", {class: "pickles", id: 'my_div'}, -> "my content goes here"

class Formstrap.Builder

  helpers: Formstrap.Helers
  content_tag: Formstrap.Helers.content_tag
  
  constructor: ->
    @fields = []
  
  to_html: ->
    (field.to_html() for field in @fields).join("\n") || "Nothing!"
    
  text: (name, options = {}) ->
    @fields.push new Formstrap.TextField(@, name, options)
    
  textArea: (name, options = {}) ->
    @fields.push new Formstrap.TextAreaField(@, name, options)

class Formstrap.FormBuilder extends Formstrap.Builder
  
  constructor: (@form_options = {}) ->
    super
    @object = @form_options.object
    delete @form_options.object
    if @object? and !@form_options.as?
      if @object.constructor and @object.constructor.toString
        arr = @object.constructor.toString().match(/function\s*(\w+)/)
        if arr and arr.length is 2
          @form_options.as = arr[1].toLowerCase()
    
  fieldset: (options..., callback) ->
    field = new Formstrap.FieldSet(Formstrap.Helers.extractOptions(options))
    field.form = @form || @
    callback(field)
    @fields.push field

  to_html: ->
    delete @form_options.as
    @content_tag "form", @form_options, super

class Formstrap.FieldSet extends Formstrap.Builder
  
  constructor: (@field_set_options = {}) ->
    super
    
  to_html: ->
    @content_tag "fieldset", @field_set_options, super

class Formstrap.Field

  helpers: Formstrap.Helers
  content_tag: Formstrap.Helers.content_tag
  
  constructor: (@builder, @name, @options = {}) ->
    @options.input ||= {}
    @compileName()
    @compileId()
    @compileClasses()
    @compileValue()
    @compileLabel()
  
  compileName: ->
    unless @options.name?
      if @builder.form.object?
        @options.input.name ||= "#{@builder.form.form_options.as}[#{@name}]"
      else
        @options.input.name = @name
      
  compileId: ->
    unless @options.input.id?
      if @builder.form.object?
        @options.input.id ||= "#{@builder.form.form_options.as}_#{@name}"
      else
        @options.input.id = @name
  
  compileClasses: ->
    @options.input.class ||= ""
    @options.input.class = "input-xlarge #{@options.input.class}"
      
  compileValue: ->
    unless @options.input.value?
      @options.input.value = ""
      if @builder.form.object?
        @options.input.value = @builder.form.object.get(@name)
  
  compileLabel: ->
    @options.label = {} unless @options.label?
    return @options.label is false
    unless @options.label?.value?
      @options.label = {}
      words = @name.split("_")
      res = for word in words
        word[0].toUpperCase() + word[1..word.length]
      @options.label.value = res.join(" ")
  
  controlGroup: (options = {}, callback) ->
    if arguments.length is 1
      callback = arguments[0]
      options = {}
    options['class'] ||= ""
    options['class'] = "control-group #{options['class']}"
    @content_tag "div", options, callback

  label: ->
    return "" if @options.label is false
    return @content_tag "label", {class: "control-label", for: @options.input.id}, @options.label.value


  to_html: -> ""
  
class Formstrap.TextField extends Formstrap.Field
  
  to_html: ->
    @controlGroup =>
      html = ""
      html += @label()
      html += @content_tag "div", {class: "controls"}, "<input type=\"text\" #{@helpers.objectToAttrs(@options.input)}>"
      return html
  
class Formstrap.TextAreaField extends Formstrap.Field
  
  to_html: ->
    @controlGroup =>
      html = ""
      html += @label()
      html += @content_tag "div", {class: "controls"}, =>
        value = @options.input.value
        delete @options.input.value
        @content_tag "textarea", @options.input, value
      return html

  

# EXAMPLES:

html = Formstrap.form_for user, (f) =>
  f.fieldset (f) =>
    f.text "first_name", input: {class: "pickles"}
    f.textArea "bio"
display html

html = Formstrap.form_for user, {action: "/users", method: "put", as: "account"}, (f) =>
  f.fieldset {class: "pickles", "data-tooltip": 'this is a "tooltip"!', "data-hover": "this is a 'hover'"}, (f) =>
    f.text "first_name"
    f.textArea "bio", label: {value: "Biography"}
display html

html = Formstrap.form (f) =>
  f.fieldset (f) =>
    f.text "first_name", input: {value: "bob", class: "pickles"},
    f.textArea "bio", input: {id: "my_bio"}
display html

html = Formstrap.form (f) =>
  f.fieldset (f) =>
    f.text "first_name", input: {value: "John"}, label: false
    f.textArea "bio"
display html

# class Formstrap.TestView extends Backbone.View
# 
#   el: '#test_formstrap'
# 
#   initialize: ->
#     super
#     @template = JST['formstrap/test_view']
#     @render()
# 
#   render: =>
#     user = new MainAndMe.Models.User(first_name: "Mark", bio: "Mark is cool")
#     $(@el).html(@template(user: user))
#     return @
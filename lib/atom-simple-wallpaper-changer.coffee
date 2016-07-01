fs   = require 'fs'
Path = require 'path'
remote = require 'remote'
browserWindow = remote.require 'browser-window'

module.exports =

  config:
    defaultImage:
      type: 'string'
      default: ''
      description: 'default image filename. (empty value for randomization)'
      order: 1
    assetsDir:
      type: 'string'
      default: '~/.atom/packages/atom-simple-wallpaper-changer/assets/'
      description: 'path to assets directory.'
      order: 2
    imageOpacity:
      type: 'number'
      default: 0.0
      minimum: 0.0
      maximum: 1.0
      description: 'image opacity. between 0.0 and 1.0'
      order: 3
    imageSize:
      type: 'string'
      default: 'contain'
      description: 'image size. background-size property value ("contain", px, %)'
      order: 4

  activate: (state) ->
    atom.commands.add 'atom-text-editor', 'atom-simple-wallpaper-changer:toggle', => @toggle()
    atom.commands.add 'atom-text-editor', 'atom-simple-wallpaper-changer:iterateImages', => @iterateImages()
    atom.config.onDidChange 'atom-simple-wallpaper-changer.imageOpacity', ({newValue, oldValue}) => @reload()
    atom.config.onDidChange 'atom-simple-wallpaper-changer.imageSize', ({newValue, oldValue}) => @reload()
    fs.readdir(@getPrefixPath(), (err, files) =>
      if (err)
        console.error(err)
        return
      @images = files.filter((x) -> /\.(?:jpg|png|gif)$/i.test(x))
      if @images.length > 1
        @current = @images.indexOf(atom.config.get('atom-simple-wallpaper-changer.defaultImage'))
        if @current == -1
          @current = Math.floor(Math.random() * @images.length)
        atom.views.getView(atom.workspace).classList.add('simple-wallpaper-changer')
        @load()
    )

  deactivate: ->
    if @element
      @element.remove()

  load: () ->
    @element = document.createElement('style')
    @element.textContent = ' .simple-wallpaper-changer .item-views /deep/ .editor--private:not(.mini) .scroll-view::after {
      opacity: ' + atom.config.get('atom-simple-wallpaper-changer.imageOpacity') + ';
      background-size: ' + atom.config.get('atom-simple-wallpaper-changer.imageSize') + ';
    }'
    @element.textContent += ' .simple-wallpaper-changer .item-views /deep/ .editor--private:not(.mini) .scroll-view::after {
      background-image: url("' + @getPrefixUrl() + @images[@current] + '");
    }'
    atom.views.getView(atom.workspace).appendChild(@element)

  toggle: ->
    atom.views.getView(atom.workspace).classList.toggle('simple-wallpaper-changer')

  iterateImages: ->
    if @images.length > 0
      @current = (@current + 1) % @images.length
      @deactivate()
      @load()

  getPrefixUrl: ->
    'atom://atom-simple-wallpaper-changer/assets/'

  getPrefixPath: ->
    home = if process.platform is 'win32' then process.env.USERPROFILE else process.env.HOME
    path = atom.config.get('atom-simple-wallpaper-changer.assetsDir')
    if path[0] is '~'
      path = home + path.substr(1)
    path = path.slice(0, -1) if path[path.length-1] is '/'
    path + '/'

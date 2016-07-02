fs = require 'fs'
remote = require 'remote'
chokidar = require 'chokidar'
browserWindow = remote.require 'browser-window'

module.exports =

  config:
    defaultImage:
      type: 'string'
      default: ''
      description: 'default image filename. (empty value for randomization)'
      order: 1
    assetsDirectory:
      type: 'string'
      default: ''
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

  activate: ->
    atom.commands.add 'atom-text-editor', 'atom-simple-wallpaper-changer:toggle', => @toggle()
    atom.commands.add 'atom-text-editor', 'atom-simple-wallpaper-changer:iterateImages', => @iterateImages()
    atom.config.onDidChange 'atom-simple-wallpaper-changer.imageOpacity', => @applyStyle()
    atom.config.onDidChange 'atom-simple-wallpaper-changer.imageSize', => @applyStyle()
    atom.config.onDidChange 'atom-simple-wallpaper-changer.assetsDirectory', =>
      @loadImages().then => @applyStyle(); @watch()
    @loadImages().then => @applyStyle(); @watch()

  deactivate: ->
    atom.views.getView(atom.workspace).classList.remove('simple-wallpaper-changer')

  watch: ->
    if @watcher
      @watcher.close()
    @watcher = chokidar.watch @path,
      ignored: /[\/\\]\./
      persistent: true
    .on 'all', (event, path) =>
      now = new Date().getTime()
      if !@date || now - @date > 1000
        @date = now
        @loadImages().then => @applyStyle()

  loadImages: ->
    new Promise (resolve, reject) =>
      @path = @getPrefixPath()
      if @path == null 
        resolve()
      else
        fs.readdir @path, (err, files) =>
          @images = (files || []).filter((x) -> /\.(?:jpg|png|gif)$/i.test(x))
          if @images.length > 1
            @current = @images.indexOf(atom.config.get('atom-simple-wallpaper-changer.defaultImage'))
            if @current == -1
              @current = Math.floor(Math.random() * @images.length)
            atom.views.getView(atom.workspace).classList.add('simple-wallpaper-changer')
          resolve()

  applyStyle: ->
    if @element
      @element.remove()
    if @images and @images.length > 1
      @element = document.createElement('style')
      @element.textContent = ' .simple-wallpaper-changer .item-views /deep/ .editor--private:not(.mini) .scroll-view::after {
        opacity: ' + atom.config.get('atom-simple-wallpaper-changer.imageOpacity') + ';
        background-size: ' + atom.config.get('atom-simple-wallpaper-changer.imageSize') + ';
      }'
      @element.textContent += ' .simple-wallpaper-changer .item-views /deep/ .editor--private:not(.mini) .scroll-view::after {
        background-image: url("file://' + @path + @images[@current] + '");
      }'
      atom.views.getView(atom.workspace).appendChild(@element)

  toggle: ->
    atom.views.getView(atom.workspace).classList.toggle('simple-wallpaper-changer')

  iterateImages: ->
    if @images and @images.length > 0
      @current = (@current + 1) % @images.length
      @applyStyle()

  getPrefixPath: ->
    home = if process.platform is 'win32' then process.env.USERPROFILE else process.env.HOME
    path = atom.config.get('atom-simple-wallpaper-changer.assetsDirectory')
    if path == ''
      return null
    if path[0] is '~'
      path = home + path.substr(1)
    try
      fs.realpathSync(path) + '/'
    catch
      null

require('zappa').run 3000, ->
  

  express = require('zappa/node_modules/express')
  
  log4js = require('log4js')
  logger = null

  @configure
    development: => 
      log4js.addAppender(log4js.consoleAppender())
      logger = log4js.getLogger('app')
      @use log4js.connectLogger logger, 
        level: log4js.levels.DEBUG
        format: ':method :url :status :response-time'

    production: => 
      log4js.configure('log4js-production.json')
      logger = log4js.getLogger('app')
      @use log4js.connectLogger logger, 
        level: log4js.levels.INFO
        format: ':method :url :status :response-time'


  
  @use 'bodyParser', 'methodOverride', @app.router
  @use 'static': __dirname + '/static'
  @use 'static': __dirname + '/node_modules/d3'
  @use 'static': __dirname + '/node_modules/crossfilter'
  @use 'static': __dirname + '/node_modules/cubism'
  @use 'static': __dirname + '/node_modules/queue-async'

  #@enable 'default layout'
  #@enable 'minify'


  @app.use (err, req, res, next) ->
    console.error err
    res.status = 
    res.send "Something went wrong..."


  @include './layout'
  @include './views'
  @include './queries'


  @configure
    development: => @use errorHandler: {dumpExceptions: on}
    production: => @use 'errorHandler'


  config = ->
  #   casper runner config properties
    @browserEngine = 'phantomjs'
  #    @browserEngine = 'slimerjs'
  #  @verbose = false
    @verbose = true
    @logThreshold = 'error'
  #  @logThreshold = 'error'
    @scenarioScriptExt = '.coffee'
    @generatePdf = false
    @scrapeHtml = true
    @scrapedHtml = {}
    @timeout = 5000
    @dirSuccess = "/RESULTS_SUCCESS/"
    @dirFailure = "/RESULTS_FAILURE/"
    @pdfResults = "/RESULTS/"
    @includeFullPage = true
    @dirScreenshotViewPort = '{scenario}/{deviceType}/{userAgentType}/{width}x{height}/STEP-{step}'
    @dirScreenshotFullPage = '{scenario}/{deviceType}/{userAgentType}/FULLPAGE/{width}x{height}/STEP-{step}'
    @passedColor = "#00FF00"
    @failedColor="#8A0808"
    @prop = 1
    @proj = {}
    self = @

    @setProject = (project) ->
      self.dirSuccess = "/RESULTS_SUCCESS/" + project + "/"
      self.dirFailure = "/RESULTS_FAILURE/" + project + "/"
      self.pdfResults = "/RESULTS/" + project + "/"
      self.projPath = '../projects/' + project + '/'
      self.proj =  require(self.projPath + 'configProject.coffee')
      self.criteriaList =  require(self.projPath + 'criteria.coffee')
      self.selectors =  require(self.projPath + 'selectors.coffee')

  #    set resolutions
    @viewPorts =  require('./viewPorts')
  #    set userAgents
    @userAgents =  require('./userAgents')
  #    common helper methods
    @setupScreenShotPath = (scenario,deviceType,userAgentType,width,height, fullpage) ->
      path = if fullpage then self.dirScreenshotFullPage else self.dirScreenshotViewPort
      path = path.replace('{scenario}', scenario)
        .replace('{deviceType}', deviceType)
        .replace('{userAgentType}', userAgentType)
        .replace('{width}', width)
        .replace('{height}', height)
      path

    @getCasperJsExec = () ->
      "casperjs"
    @logWithTime = (scenario, step, action) ->
      if self.verbose
        timeStamp = new Date()
  #      console.log  'SCENARIO: ' + scenario + ' -> ' + timeStamp + " : " + action + ' in the step ' + step
        timeStamp

    @logTimeToComplete = (scenario, step, start) ->
  #    console.log 'completed ' + step + ' step of  ' + scenario + ' in ' + ((new Date() - start) / 1000).toFixed(3).toString() + ' secs'

    @waitFor = (casper, step, selector, next, pass, timeout) ->
      casper.waitForSelector selector, (->
        casper.then ->
          next()
        casper.then ->
          pass casper, step
      ), ->
        timeout casper, step
      return


    return

  config.instance = null
  config.getInstance = () ->
    if config.instance is null
      config.instance = new config()
    console.log config.instance.passedColor
    return config.instance


  module.exports = exports = new config()
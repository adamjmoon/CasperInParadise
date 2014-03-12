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
    @dirSuccess = "./RESULTS/{project}/SUCCESS/"
    @dirFailure = "./RESULTS/{project}/FAILURE/"
    @pdfResults = "./RESULTS/{project}/"
    @includeFullPage = true
    @dirScreenshotViewPort = '{scenario}/{deviceType}/{userAgentType}/{width}x{height}/STEP-{step}'
    @dirScreenshotFullPage = '{scenario}/{deviceType}/{userAgentType}/FULLPAGE/{width}x{height}/STEP-{step}'
    @passedColor = "#00FF00"
    @failedColor="#8A0808"
    self = @

    @setProject = (project) ->
      self.dirSuccess = self.dirSuccess.replace('{project}', project)
      self.dirFailure = self.dirFailure.replace('{project}', project)
      self.pdfResults = self.pdfResults.replace('{project}', project)
      self.projPath = '../projects/' + project + '/'
      self.path = '../../../../projects/' + project + '/'
      self.currentProject = project  
      self.proj =  require(self.projPath + 'configProject.coffee')
      self.criteriaList =  require(self.projPath + 'criteria.coffee')
      self.selectors =  require(self.projPath + 'selectors.coffee')
      return

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
      "./node_modules/.bin/casperjs"
    @logWithTime = (scenario, step, action) ->
      if self.verbose
        timeStamp = new Date()
  #      console.log  'SCENARIO: ' + scenario + ' -> ' + timeStamp + " : " + action + ' in the step ' + step
        timeStamp

    @logTimeToComplete = (scenario, step, start) ->
#    console.log 'completed ' + step + ' step of  ' + scenario
#+ ' in ' + ((new Date() - start) / 1000).toFixed(3).toString() + ' secs'

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


module.exports = new config()
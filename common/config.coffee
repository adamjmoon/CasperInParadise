config = ->
  #   casper runner config properties
    @browserEngine = 'phantomjs'
    @verbose = true
    @logThreshold = 'error'
    @scenarioScriptExt = '.coffee'
    @generatePdf = false
    @scrapeHtml = true
    @scrapedHtml = {}
    @timeout = 5000
    @dirSuccess = "./RESULTS/{project}/SUCCESS/"
    @dirFailure = "./RESULTS/{project}/FAILURE/"
    @pdfResults = "./RESULTS/{project}/{scenario}"
    @includeFullPage = true
    @passedColor = "#00FF00"
    @failedColor="#8A0808"
    
    self = @

    @setProject = (project) ->
      if project
        self.dirSuccess = self.dirSuccess.replace('{project}', project)
        self.dirFailure = self.dirFailure.replace('{project}', project)
        self.pdfResults = self.pdfResults.replace('{project}', project)
        self.currentProject = project
      return
    
    @setProject 'etsy'

  #    set resolutions
    @viewPorts =  require('./viewPorts.coffee')
  #    set userAgents
    @userAgents =  require('./userAgents.coffee')
  #    common helper methods
    
    @utils =  require('./utils.coffee')

    return


module.exports = new config()
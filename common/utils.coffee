growl = require('growl')

utils =
  setupScreenShotPath: (scenario,deviceType,userAgentType,width,height, fullpage) ->
        path = if fullpage then self.dirScreenshotFullPage else self.dirScreenshotViewPort
        path = path.replace('{scenario}', scenario)
          .replace('{deviceType}', deviceType)
          .replace('{userAgentType}', userAgentType)
          .replace('{width}', width)
          .replace('{height}', height)
        path
        return

  getCasperJsExec: () ->
    "./node_modules/.bin/casperjs"

  logWithTime : (scenario, step, action) ->
    if self.verbose
      timeStamp = new Date()
      console.log  'SCENARIO: ' + scenario + ' -> ' + timeStamp + " : " + action + ' in the step ' + step
      return timeStamp
      

  logTimeToComplete: (scenario, step, start) ->
    console.log 'completed ' + step + ' step of  ' + scenario + ' in ' + ((new Date() - start) / 1000).toFixed(3).toString() + ' secs'

  growlMsg : (msg) ->
      unless typeof (growl) is "undefined"
        growl msg,
          title: "STATUS UPDATE",
          priority: 1


module.exports = utils

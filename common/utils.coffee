utils =
  setupScreenShotPath: (scenario,deviceType,userAgentType,width,height, fullpage) ->
    dirScreenshotViewPort = '{scenario}/{deviceType}/{userAgentType}/{width}x{height}/STEP-{step}'
    dirScreenshotFullPage = '{scenario}/{deviceType}/{userAgentType}/FULLPAGE/{width}x{height}/STEP-{step}'
    path = if fullpage then dirScreenshotFullPage else dirScreenshotViewPort
    path = path.replace('{scenario}', scenario)
      .replace('{deviceType}', deviceType)
      .replace('{userAgentType}', userAgentType)
      .replace('{width}', width)
      .replace('{height}', height)
    path
    return


    
  logWithTime : (scenario, step, action) ->
    if self.verbose
      timeStamp = new Date()
      console.log  'SCENARIO: ' + scenario + ' -> ' + timeStamp + " : " + action + ' in the step ' + step
      return timeStamp
      

  logTimeToComplete: (scenario, step, start) ->
    console.log 'completed ' + step + ' step of  ' + scenario + ' in ' + ((new Date() - start) / 1000).toFixed(3).toString() + ' secs'


module.exports = utils

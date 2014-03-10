
require = patchRequire global.require
x = require('casper').selectXPath
common = require "./common/config.coffee"
casper = require('casper').create
    verbose: true
    logLevel: 'error'
    waitTimeout: 5000
requestedProject = casper.cli.get(0)
scraped = require "./common/scraped.coffee"
scraped.html = ''
common.setProject(requestedProject)
scenario = casper.cli.get(1)
deviceType = casper.cli.get(2)
width = casper.cli.get(3)
height = casper.cli.get(4)
userAgentType = casper.cli.get(5)

url = common.proj.url

steps = []
successCount = 0
failedCount = 0
successImgPath = ''
failureImgPath = ''

buildSteps = (scenario) ->
  for st in common.criteriaList[scenario].steps
    if common.criteriaList[st] and common.criteriaList[st].steps.length > 1
      buildSteps st
    else
      steps.push st

buildSteps(scenario)

ACfilename = common.setupScreenShotPath scenario, deviceType, userAgentType, width, height, false
FPfilename = common.setupScreenShotPath scenario, deviceType, userAgentType, width, height, true

#set the userAgent from argument passed in
casper.userAgent common.userAgents[deviceType][userAgentType]

casper.show = (selector) ->
  @evaluate ((selector) ->
    document.querySelector(selector).style.display = "block !important;"
  ), selector



pass = (c, step)->
  #console.log 'step -> ' + step + ' html:\n' + c.getHTML()
  console.log common.dirSuccess + ACfilename.replace(/{step}/g, currentStep + '-' + step) + '.png'
  c.capture common.dirSuccess + ACfilename.replace(/{step}/g, currentStep + '-' + step) + '.png',
    top: 0
    left: 0
    width: width
    height: height

  if common.includeFullPage 
  then c.captureSelector common.dirSuccess + FPfilename.replace(/{step}/g, currentStep + '-' + step) + '.png', 'html'


  common.logWithTime scenario, step, ' snapshot taken after pass'
  successCount = successCount + 1
  runSteps c
  return

fail = (c, step) ->
  c.capture common.dirFailure + ACfilename.replace(/{step}/g, currentStep + '-' + step) + '.png',
    top: 0
    left: 0
    width: width
    height: height
  c.captureSelector common.dirFailure + FPfilename.replace(/\{step\}/g, currentStep + '-' + step) + '.png', 'body'

  common.logWithTime scenario, step, ' snapshot taken after failure'
  failedCount = failedCount + 1
  return

currentStep = 0

runSteps = (c) ->
  if steps[currentStep]
    step = steps[currentStep]
    stepToRun = require(common.projPath + "scenarios/" + step + common.scenarioScriptExt)
    common.logWithTime(scenario, currentStep + 1, ' run')
    stepToRun.run c, scenario, step, common, pass, fail, x
    currentStep++
  return

casper.start url

casper.then ->
  @viewport width, height
  return

casper.then ->
  runSteps casper
  return

exitCode = ->
  successCount*10 + failedCount

casper.run ->
  exitCode = successCount*10 + failedCount
  @echo("Exiting with exit code " + exitCode).exit(exitCode)
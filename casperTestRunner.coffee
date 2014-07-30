#require = patchRequire global.require

x = require('casper').selectXPath
path = require 'path'
casper = require('casper').create
    verbose: true
    logLevel: 'debug'
    waitTimeout: 10000
requestedProject = casper.cli.get(0)
projectPath = "projects/" + requestedProject + "/config.coffee"
config = require(projectPath)
common = require("common/config.coffee")
scenario = casper.cli.get(1)
console.log scenario
deviceType = casper.cli.get(2)
width = casper.cli.get(3)
height = casper.cli.get(4)
userAgentType = casper.cli.get(5)
projRoot = casper.cli.get(6)

steps = []
successCount = 0
failedCount = 0
successImgPath = ''
failureImgPath = ''
casper.tap = (selector) ->
  @evaluate ->
    el = document.querySelector(selector)
    Hammer = hammer(el)
    console.log Hammer
    Hammer.trigger('tap', target: el)
    return
  return


buildSteps = (scenario) ->
  for st in config.criteriaList[scenario].steps
    if config.criteriaList[st] and config.criteriaList[st].steps.length >= 1
      buildSteps st
    else
      steps.push st

buildSteps(scenario)

ACfilename = common.utils.setupScreenShotPath scenario, deviceType, userAgentType, width, height, false
FPfilename = common.utils.setupScreenShotPath scenario, deviceType, userAgentType, width, height, true

#set the userAgent from argument passed in
console.log common.userAgents[deviceType][userAgentType]
casper.userAgent common.userAgents[deviceType][userAgentType]

imgPath = ""
pass = (casper, step)->
  #console.log c.getHTML()
  imgPath = common.dirSuccess + ACfilename.replace(/{step}/g, currentStep + '-' + step) + '.png'
  casper.capture imgPath,
    top: 0
    left: 0
    width: width
    height: height
    
  

  if common.includeFullPage 
  then casper.captureSelector common.dirSuccess + FPfilename.replace(/{step}/g, currentStep + '-' + step) + '.png', 'html'
  
  common.utils.logWithTime scenario, step, ' snapshot taken after pass'
  successCount = successCount + 1
  runSteps casper
  return

fail = (casper, step) ->
  #console.log c.getHTML()
  
  casper.capture common.dirFailure + ACfilename.replace(/{step}/g, currentStep + '-' + step) + '.png',
    top: 0
    left: 0
    width: width
    height: height
  casper.captureSelector common.dirFailure + FPfilename.replace(/\{step\}/g, currentStep + '-' + step) + '.png', 'body'

  common.utils.logWithTime scenario, step, ' snapshot taken after failure'
  failedCount = failedCount + 1
  return

currentStep = 0
stepConfig = {proj : config, pass : pass, fail : fail}
caspertUtils = require('common/casperUtils.coffee')             

runSteps = (casper) ->
  if steps[currentStep]
    step = steps[currentStep]
    stepScriptModule = "projects/" + requestedProject + "/scenarios/" + step + common.scenarioScriptExt
    stepToRun = require(stepScriptModule)
    stepConfig.step = step
    stepToRun casper, stepConfig, caspertUtils
    currentStep++
  return

casper.start config.url

casper.then ->
  console.log width
  console.log height
  @viewport width, height
  return

casper.then ->
  runSteps casper
  return

exitCode = ->
  return successCount*10 + failedCount

casper.run ->
  exitCode = successCount*10 + failedCount
  @exit(exitCode)

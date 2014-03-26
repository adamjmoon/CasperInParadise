require = patchRequire global.require
x = require('casper').selectXPath
path = require 'path'
casper = require('casper').create
    verbose: true
    logLevel: 'debug'
    waitTimeout: 5000
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
casper.userAgent common.userAgents[deviceType][userAgentType]

casper.show = (selector) ->
  @evaluate ((selector) ->
    document.querySelector(selector).style.display = "block !important;"
  ), selector

pass = (c, step)->
  console.log c.getHTML()
  c.capture common.dirSuccess + ACfilename.replace(/{step}/g, currentStep + '-' + step) + '.png',
    top: 0
    left: 0
    width: width
    height: height

  if common.includeFullPage 
  then c.captureSelector common.dirSuccess + FPfilename.replace(/{step}/g, currentStep + '-' + step) + '.png', 'html'


  common.utils.logWithTime scenario, step, ' snapshot taken after pass'
  successCount = successCount + 1
  runSteps c
  return

fail = (c, step) ->
  console.log(step +' -> ' + '\n------------------------\n' + c.getHTML() + '\n-----------------------\n')
  
  c.capture common.dirFailure + ACfilename.replace(/{step}/g, currentStep + '-' + step) + '.png',
    top: 0
    left: 0
    width: width
    height: height
  c.captureSelector common.dirFailure + FPfilename.replace(/\{step\}/g, currentStep + '-' + step) + '.png', 'body'

  common.utils.logWithTime scenario, step, ' snapshot taken after failure'
  failedCount = failedCount + 1
  return

currentStep = 0

runSteps = (c) ->
  
  if steps[currentStep]
    step = steps[currentStep]
    stepScriptModule = projRoot + requestedProject + "/scenarios/" + step + common.scenarioScriptExt
    stepToRun = require(stepScriptModule)
    common.utils.logWithTime(scenario, currentStep + 1, ' run')
    stepToRun c, scenario, step, config, pass, fail, x
    currentStep++
  return

console.log config.url
casper.start config.url

casper.then ->
  @viewport width, height
  return

casper.then ->
  console.log steps
  runSteps casper
  return

exitCode = ->
  successCount*10 + failedCount

casper.run ->
  exitCode = successCount*10 + failedCount
  @exit(exitCode)

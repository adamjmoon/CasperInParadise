require = patchRequire global.require
x = require('casper').selectXPath
path = require 'path'
casper = require('casper').create
    verbose: true
    logLevel: 'debug'
    waitTimeout: 10000
requestedProject = casper.cli.get(0)
projectPath = "./projects/" + requestedProject + "/config.coffee"
config = require(projectPath)
common = require("common/config.coffee")
scenario = casper.cli.get(1)
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
    if config.criteriaList[st] and config.criteriaList[st].steps.length > 1
      buildSteps st
    else
      steps.push st
      console.log steps

console.log scenario
buildSteps(scenario)

ACfilename = common.utils.setupScreenShotPath scenario, deviceType, userAgentType, width, height, false
FPfilename = common.utils.setupScreenShotPath scenario, deviceType, userAgentType, width, height, true

#set the userAgent from argument passed in

console.log common.userAgents[deviceType][userAgentType]
casper.userAgent common.userAgents[deviceType][userAgentType]

pass = (c, step)->
  console.log '--------------- ' + step + ' ----------------\n'
  console.log c.getHTML()
  console.log '--------------- ' + step + ' ----------------\n'
  c.capture common.dirSuccess + ACfilename.replace(/{step}/g, currentStep + '-' + step) + '.png',
    top: 0
    left: 0
    width: width
    height: height

  if common.includeFullPage 
  then c.captureSelector common.dirSuccess + FPfilename.replace(/{step}/g, currentStep + '-' + step) + '.png', 'html'


#  common.utils.logWithTime scenario, step, ' snapshot taken after pass'
  successCount = successCount + 1
  runSteps c
  return

fail = (c, step) ->
  #console.log c.getHTML()
  
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
  if steps[currentStep]?
    try
      step = steps[currentStep]
      stepScriptModule = "projects/" + requestedProject + "/scenarios/" + step + '.coffee'
      stepToRun = require(stepScriptModule)
      common.utils.logWithTime(scenario, currentStep + 1, ' run')
      config.step = step

      stepToRun c, config
      currentStep++
    catch ex
      console.log ex

  return

casper.start config.url

casper.then ->
  console.log width
  console.log height
  @viewport width, height
  return

casper.then ->
  console.log steps
  config.pass = pass
  config.fail = fail
  config.scenario = scenario
  runSteps casper
  return

exitCode = ->
  return successCount*10 + failedCount

casper.run ->
  exitCode = successCount*10 + failedCount
  @exit(exitCode)

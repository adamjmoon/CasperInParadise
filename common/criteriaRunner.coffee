async = require( "async" )
Sync = require("sync")
common = require( "./config.coffee" )
cmd = require("./cmd.coffee")
exp = {}
workList = []

setupWorkForProjectAndDevice = ( proj , deviceType , scenario , cb ) ->
  if scenario
    setupWorkForScenario proj, scenario , deviceType , cb
  else
    for scenario of proj.criteriaList
      if proj.criteriaList[ scenario ].filter
        if proj.criteriaList[ scenario ].filter[ deviceType ]
          setupWorkForScenario proj, scenario , deviceType , cb
      else
        setupWorkForScenario proj, scenario , deviceType , cb
  return

setupWorkForScenario = (proj, scenario , deviceType , cb ) ->
  i = 0
  while i < common.viewPorts[ deviceType ].list.length
    for userAgentType of common.userAgents[ deviceType ]
      args = [ 'casperTestRunner.coffee', proj.name, scenario, deviceType,
               common.viewPorts[ deviceType ].list[ i ][ 0 ],
               common.viewPorts[ deviceType ].list[ i ][ 1 ] ]
      # pass type of device or browser
      args.push userAgentType
      args.push __dirname.replace('common','projects/')
      # pass actual userAgent string
      args.push '--engine=' + common.browserEngine
      
      workList.push async.apply( cmd , './node_modules/.bin/casperjs', args , cb )
    i++
  return

queueWork = ( project , deviceType , scenario, cb, callback) ->
  proj = require( '../projects/' + project + '/config.coffee' )
  
#     SETUP WORK LIST FIRST
  if deviceType
    setupWorkForProjectAndDevice( proj , deviceType , scenario , cb ) if common.viewPorts[ deviceType ].active
    callback(null, workList)
  else
    setupWorkForProjectAndDevice( proj , 'phone' , scenario , cb ) if common.viewPorts.phone.active
    setupWorkForProjectAndDevice( proj , 'tablet' , scenario , cb ) if common.viewPorts.tablet.active
    setupWorkForProjectAndDevice( proj , 'desktop' , scenario , cb ) if common.viewPorts.desktop.active
    callback(null, workList)
  return

#     NOW PROCESS THE WORK LIST IN PARALLEL
exp.run = (project , deviceType , scenario, cb) ->
  cnt = 0
  startTime = Date.now()
  callback = ( err ) ->
    cnt = cnt + 1
    if cnt == workList.length
      endTime = Date.now()
      successMsg = 'PASSED STEPS: ' + successCount
      failedMsg = ''
      if failedCount > 0
        failedMsg = "FAILED STEPS: " + failedCount
      doneMsg = common.utils.getCasperJsExec() + ' COMPLETED for all criteria in : ' + ((endTime - startTime) / 1000).toFixed( 3 ).toString() + ' seconds'
      #common.utils.growlMsg( doneMsg )
      console.log doneMsg.cyan
      console.log successMsg.green
      if failedMsg.length > 0
        console.log failedMsg.red
      cb(null, true)
  
  try
    work = queueWork.sync(null, project, deviceType, scenario, callback)
    console.log(work)
    result = async.parallel.sync null, work
  catch e
    console.error e  # something went wrong
  return

module.exports = exp
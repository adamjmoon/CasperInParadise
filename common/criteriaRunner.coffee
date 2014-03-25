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
      # pass actual userAgent string
      args.push '--engine=' + common.browserEngine
      workList.push async.apply( cmd , common.utils.getCasperJsExec() , args , cb )
    i++
  return

queueWork = ( project , deviceType , scenario, callback) ->
  proj = require( '../projects/' + project + '/config.coffee' )
  console.log proj
#     SETUP WORK LIST FIRST
  if deviceType
    setupWorkForProjectAndDevice( proj , deviceType , scenario , callback ) if common.viewPorts[ deviceType ].active
    callback(null, workList)
  else
    setupWorkForProjectAndDevice( proj , 'phone' , scenario , callback ) if common.viewPorts.phone.active
    setupWorkForProjectAndDevice( proj , 'tablet' , scenario , callback ) if common.viewPorts.tablet.active
    setupWorkForProjectAndDevice( proj , 'desktop' , scenario , callback ) if common.viewPorts.desktop.active
    callback(null, workList)
  return

#     NOW PROCESS THE WORK LIST IN PARALLEL
exp.runInParallel = (project , deviceType , scenario, cb) ->
  console.log(project)
  Sync ->
    console.log(project)
    work = queueWork.sync(null, project, deviceType, scenario)
    cnt = 0
    startTime = Date.now()
    callback = ( err , results ) ->
      cnt = cnt + 1
      if cnt == workList.length
        endTime = Date.now()
        successMsg = 'PASSED STEPS: ' + successCount
        failedMsg = ''
        if failedCount > 0
          failedMsg = "FAILED STEPS: " + failedCount
        doneMsg = common.utils.getCasperJsExec() + ' COMPLETED for all criteria in : ' + ((endTime - startTime) / 1000).toFixed( 3 ).toString() + ' seconds'
        common.utils.growlMsg( doneMsg )
        console.log doneMsg.cyan
        console.log successMsg.green
        if failedMsg.length > 0
          console.log failedMsg.red
        cb()
    console.log(work)
    return work
  return


module.exports = exp
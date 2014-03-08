module.exports = (grunt) ->
  async = require("async")
  spawn = require('child_process').spawn
  fs = require('fs')
  colors = require('colors')
  _ = require('lodash')
  path = require('path')
  PDF = require 'pdfkit'
  growl = require('growl')
  scraped = require "./common/scraped.coffee"
  common = require "./common/config.coffee"
  stats = require "./common/stats.coffee"
  stats.failures = 1

  console.log common.prop = 3
  argProject = grunt.option('proj')
  common.setProject(argProject)
  workList = []
  argScenario = grunt.option('scenario')
  argDeviceType = grunt.option('deviceType')
  argUserAgentType = grunt.option('userAgent')
  successCount = 0
  failedCount = 0
  commandTxt = 'casperjs.bat casperTestRunner.coffee '
  grunt.loadNpmTasks 'grunt-contrib-clean'

  # Configure Grunt
  grunt.initConfig
    clean: {options: {force: true}, all: [common.dirSuccess, common.dirFailure]}

  grunt.registerTask 'testAcceptanceCriteria', 'RUN ALL CRITERIA', () ->
    run this.async()

  grunt.registerTask 'default', ['clean', 'testAcceptanceCriteria']

  setupWork = (deviceType, cb) ->
    if argScenario
      setupWorkForScenario argScenario, deviceType, cb
    else
      for scenario of common.criteriaList
        setupWorkForScenario scenario, deviceType, cb

  setupWorkForScenario = (scenario, deviceType, cb) ->
    if common.criteriaList[scenario].forDeviceType is deviceType or !common.criteriaList[scenario].forDeviceType
      i = 0
      while i < common.viewPorts[deviceType].list.length
        if argUserAgentType
          args = ['casperTestRunner.coffee', common.currentProject, scenario, deviceType, common.viewPorts[deviceType].list[i][0],
                  common.viewPorts[deviceType].list[i][1]]
          # pass type of device or browser
          args.push argUserAgentType
          # pass actual userAgent string
          args.push '--engine=' + common.browserEngine
          args.push common
          console.log args

#          workList.push async.apply(cmd, common.getCasperJsExec(), args, cb)
        else
          for userAgentType of common.userAgents[deviceType]
            args = ['casperTestRunner.coffee', common.currentProject, scenario, deviceType, common.viewPorts[deviceType].list[i][0],
                    common.viewPorts[deviceType].list[i][1]]
            # pass type of device or browser
            args.push userAgentType
            # pass actual userAgent string
            args.push '--engine=' + common.browserEngine
            args.push common
            console.log args
            workList.push async.apply(cmd, common.getCasperJsExec(), args, cb)
        i++


  run = (cb) ->
    cnt = 0
    startTime = Date.now()
    callback = (err, results) ->
      cnt = cnt + 1
      if cnt == workList.length
        endTime = Date.now()
        successMsg = 'PASSED STEPS: ' + successCount
        failedMsg = ''
        if failedCount > 0
          failedMsg = "FAILED STEPS: " + failedCount
        doneMsg = common.getCasperJsExec() + ' COMPLETED for all criteria in : ' + ((endTime - startTime) / 1000).toFixed(3).toString() + ' seconds'
        growlMsg(doneMsg  .cyan)
#        console.log doneMsg .cyan
#        console.log successMsg .green
#        if failedMsg.length > 0
#          console.log failedMsg .red

        console.log scraped
        cb()

    if argDeviceType
      setupWork(argDeviceType, callback) if common.viewPorts[argDeviceType].active
    else
      setupWork('phone', callback) if common.viewPorts['phone'].active
      setupWork('tablet', callback) if common.viewPorts.tablet.active
      setupWork('desktop', callback) if common.viewPorts.desktop.active

    async.parallel workList,
      callback

  appendPdfForPath = (path, doc, failed, cb) ->
    if (fs.existsSync(path))
      doc.fontSize(18)
      files = fs.readdirSync path
      files = _.sortBy files
      text = ''
      stepDesc
      stepNum
      j = 0
      imgPath = ''
      headerHeight = 0
      while j < files.length
        stepNum =  files[j].replace(/(STEP-)(.*)-(.*)(\.png)/,'$2')
        stepDesc =  files[j].replace(/(STEP-)(.*)-(.*)(\.png)/,'$3')
        imgPath = path + files[j]
        text =   "#"+ stepNum + ': ' + stepDesc

        doc.addPage()

        doc.text(text,20,headerHeight + 5)
          .highlight(0, 0, doc.page.width+5, 25)
          .circle(10,11+headerHeight, 7)
          .lineWidth(1)
        if failed
           doc.fillAndStroke("#FE2E2E", common.failedColor)
        else
           doc.fillAndStroke("#00FF00", "green")
        doc.rect(0,headerHeight + 22, doc.page.width, 3).fillAndStroke("black", "#000000")
        doc.image(imgPath, 0, headerHeight + 25 )
        j++
    cb()
    doc

  cmd = (script, args, callback) ->
    cmdProcess = spawn script, args, {stdio: 'inherit'}

    cmdProcess.on "exit", (code) ->
      msg = '\ndeviceType: ' + args[5] + '\nviewport:  ' + args[4] + ' x ' + args[5] + '\n-----------------------------------\n'
      path = args[2] + '/' + args[3] + '/' + args[6] + '/' +  args[4] + 'x' + args[5] + '/'
      sPath = common.dirSuccess + path
      fPath = common.dirFailure + path
      pdfResult =  args[2] + '-' + args[3] + '-' + args[6] + '-' + args[4] + '-' + args[5] + '.pdf'

      hadFailure = code % 10 > 0
      scenarioTitle = args[2] + '\n'
      successCount = successCount + Math.floor( code / 10 )
      if common.generatePdf
        doc = new PDF
          size:
            [args[4] , args[5]+25]

        if common.criteriaList[args[2]].bdd
          scenarioTitle = scenarioTitle +
            '\n\nGIVEN:\n--> ' + common.criteriaList[args[2]].bdd.GIVEN +
            '\nWHEN:\n--> ' + common.criteriaList[args[2]].bdd.WHEN +
            '\nTHEN:\n--> ' + common.criteriaList[args[2]].bdd.THEN

        doc.fontSize(16)
        .text(scenarioTitle,Math.floor(doc.page.width/12),Math.floor(doc.page.height/12),{width: Math.floor(doc.page.width*.9), align: 'left'})

        appendPdfForPath(sPath, doc, false, () ->
          if hadFailure
            failedCount = failedCount + 1
            appendPdfForPath fPath, doc, true,() ->
              doc.write fPath + pdfResult
          else
            doc.write sPath + pdfResult
        )
      if hadFailure
        msg = 'COMPLETED ' + args[2] + ' but FAILED on Step ' + common.criteriaList[args[2]].steps[Math.floor( code / 10 )] + msg
        console.log msg .red
      else
        msg =  'COMPLETED All ' + common.criteriaList[args[2]].steps.length + ' Steps for ' + args[1] + ' Successfully '  + msg
        console.log msg .green
      callback(null, "")

  growlMsg = (msg) ->
    unless typeof (growl) is "undefined"
      growl msg,
        title: "STATUS UPDATE",
        priority: 1
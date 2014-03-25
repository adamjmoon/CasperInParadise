spawn = require('child_process').spawn
cmd = (script, args, callback) ->
  fs = require('fs')
  logFile = './logs/' + args[1] + '.' + args[2] +  '.' + args[6] + '.log'
  out = fs.openSync(logFile, 'w')
  err = out

  cmdProcess = spawn script, args, {stdio: [ 'pipe', out, err ]}

  cmdProcess.on "exit", (code) ->

    msg = '\ndeviceType: ' + args[3] + '\nviewport:  ' + args[4] + ' x ' + args[5] + '\n-----------------------------------\n'
    path = args[2] + '/' + args[3] + '/' + args[6] + '/' +  args[4] + 'x' + args[5] + '/'
    sPath = common.dirSuccess + path
    fPath = common.dirFailure + path
    pdfResult =  args[2] + '-' + args[3] + '-' + args[6] + '-' + args[4] + '-' + args[5] + '.pdf'

    hadFailure = code % 10 > 0
    scenarioTitle = args[2] + '\n'
    successCount = successCount + Math.floor( code / 10 )
    if common.generatePdf
  #        doc = new PDF
  #          size:
  #            [args[4] , args[5]+25]

      if config.criteriaList[args[2]].bdd
        scenarioTitle += '\n\nGIVEN:\n--> ' + config.criteriaList[args[2]].bdd.GIVEN
        if scenarioTitle then scenarioTitle += '\nWHEN:\n--> ' + common.criteriaList[args[2]].bdd.WHEN +
        scenarioTitle += '\nTHEN:\n--> ' + config.criteriaList[args[2]].bdd.THEN

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
      msg = 'COMPLETED ' + args[2] + ' but FAILED on Step ' + config.criteriaList[args[2]].steps[Math.floor( code / 10 )] + msg
      console.log msg .red
    else
      msg =  'COMPLETED All ' + config.criteriaList[args[2]].steps.length + ' Steps for ' + args[1] + ' Successfully '  + msg
      console.log msg .green
    callback(null, "")
    return
  return

module.exports = cmd
PDF = require 'pdfkit'
fs = require('fs')
doc = undefined

pdfHelper =
  getDoc : ->
    return doc
  create : (options) ->
    doc = new PDF
              size:
                [options.width, options.height+25]
    doc.fontSize(18)
    doc.write options.pdfPath

  appendToPDF :(options, cb) ->
      if (fs.existsSync(options.pdfPath))
        
        files = fs.readdirSync path
        files = _.sortBy files
        text = ''
        stepDesc
        stepNum
        j = 0
        headerHeight = 0
        
        
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
        doc.image(options.imgPath, 0, headerHeight + 25 )
        j++
      else
        
      if cb
        cb()
      doc.write options.pdfPath

module.exports = pdfHelper
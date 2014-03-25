PDF = require 'pdfkit'
fs = require('fs')
doc = undefined

pdfHelper =
  getDoc : ->
    return doc
  create : (width, height) ->
    doc = new PDF
              size:
                [width, height]


  appendToPDF :(path, failed, cb) ->
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

module.exports = pdfHelper
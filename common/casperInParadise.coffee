CasperInParadise = ->
  CasperInParadise.super_.apply this, arguments_
  return
Casper = require("casper").Casper
utils = require("utils")
links =
  "http://edition.cnn.com/": 0
  "http://www.nytimes.com/": 0
  "http://www.bbc.co.uk/": 0
  "http://www.guardian.co.uk/": 0


# Let's make our Fantomas class extending the Casper one
# please note that at this point, CHILD CLASS PROTOTYPE WILL BE OVERRIDEN
utils.inherits CasperInParadise, Casper
CasperInParadise::countLinks = ->
  @evaluate ->
    __utils__.findAll("a[href]").length


CasperInParadise::renderJSON = (what) ->
  @echo JSON.stringify(what, null, "  ")

CasperInParadise::browseTo = (baseUrl, route) ->
  return this.evaluate ->
    this.thenOpen baseUrl + route,( ->
      this.waitForUrl route, ( ->
        this.then ->
          return config.pass
      ), ->
        casper.then ->
          this.echo(this.getCurrentUrl())
          return config.fail
    )

CasperInParadise::capturePDF = (options) ->
  appendToPDF = undefined
  create = undefined
  create = (options) ->
    doc = undefined
    doc = new PDF(size: [
      options.width
      options.height + 25
    ])
    doc.fontSize 18
    doc.write options.pdfPath

  appendToPDF = (options, cb) ->
    files = undefined
    headerHeight = undefined
    j = undefined
    text = undefined
    if fs.existsSync(options.pdfPath)
      files = fs.readdirSync(path)
      files = _.sortBy(files)
      text = ""
      stepDesc
      stepNum
      j = 0
      headerHeight = 0
      text = "#" + stepNum + ": " + stepDesc
      doc.addPage()
      doc.text(text, 20, headerHeight + 5).highlight(0, 0, doc.page.width + 5, 25).circle(10, 11 + headerHeight, 7).lineWidth 1
      if failed
        doc.fillAndStroke "#FE2E2E", common.failedColor
      else
        doc.fillAndStroke "#00FF00", "green"
      doc.rect(0, headerHeight + 22, doc.page.width, 3).fillAndStroke "black", "#000000"
      doc.image options.imgPath, 0, headerHeight + 25
      j++
    else

    cb()  if cb
    doc.write options.pdfPath

  create options  if doc is undefined
  appendToPDF options
  return

module.exports = CasperInParadise
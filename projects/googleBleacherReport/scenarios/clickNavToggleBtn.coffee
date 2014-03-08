exports.run = (casper, scenario, step, c, p, t, x) ->
  c.logWithTime scenario, step, " inside run"
  casper.waitUntilVisible c.selectors.bleacherReportNavToggle, (->
    casper.mouse.move c.selectors.bleacherReportNavToggle
    casper.click c.selectors.bleacherReportNavToggle
    casper.wait 1000, ->
      c.logWithTime scenario, step, " about to call passed"
      p casper, step
  ), ->
    c.logWithTime scenario, step, " about to call timeout"
    t casper, step
exports.run = (casper, scenario, step, c, p, t, x) ->
  c.logWithTime scenario, step, " inside run"
  casper.waitUntilVisible c.selectors.closeDowloadAppHeader, (->
    casper.mouse.move c.selectors.closeDowloadAppHeader
    casper.click c.selectors.closeDowloadAppHeader
    casper.wait 500, ->
      c.logWithTime scenario, step, " about to call passed"
      p casper, step
  ), ->
    c.logWithTime scenario, step, " about to call timeout"
    t casper, step
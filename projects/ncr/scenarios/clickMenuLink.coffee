exports.run = (casper, scenario, step, c, p, t) ->
  c.logWithTime scenario, step, " inside run"
  casper.waitForSelector c.selectors.menuLink, (->
    casper.click c.selectors.menuLink
    casper.then ->
      casper.wait 3000, (->
        c.logWithTime scenario, step, " about to call passed"
        p casper, step
      ), ->
        c.logWithTime scenario, step, " about to call failed"
        t casper, step

  ), ->
    c.logWithTime scenario, step, " about to call failed"
    t casper, step

exports.run = (casper, scenario, step, c, p, t) ->
  
  c.logWithTime scenario, step, " inside run"
  casper.waitUntilVisible c.selectors.shopName, (->
    casper.wait 500, ->
          c.logWithTime scenario, step, " about to call passed"
          p casper, step
  ), ->
    c.logWithTime scenario, step, " about to call failed"
    t casper, step

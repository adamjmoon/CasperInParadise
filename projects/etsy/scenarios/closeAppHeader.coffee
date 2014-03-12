exports.run = (casper, scenario, step, c, p, t) ->
  Hammer = require "./node_modules/hammerjs/hammer.js"
  console.log Hammer
  casper.waitUntilVisible c.selectors.pageTitle, (->
    casper.then ->
        casper.tap c.selectors.closeAppHeaderSpan, ->
            p casper, step
            
  ), ->
    c.logWithTime scenario, step, " about to call failed"
    t casper, step

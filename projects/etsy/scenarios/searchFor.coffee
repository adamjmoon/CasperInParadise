exports.run = (casper, scenario, step, c, p, t) ->
  casper.waitUntilVisible c.selectors.pageTitle, (->
    casper.thenOpen('/search?q=knives&ship_to=US', ->
    p casper, step    
            
  ), ->
    c.logWithTime scenario, step, " about to call failed"
    t casper, step

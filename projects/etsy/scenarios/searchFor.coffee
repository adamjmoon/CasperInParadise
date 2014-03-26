module.exports = (casper, scenario, step, c, p, t) ->
  casper.waitUntilVisible c.selectors.pageTitle, (->
    casper.thenOpen('/search?q=knives&ship_to=US', ->
      p casper, step
  ), ->
    t casper, step

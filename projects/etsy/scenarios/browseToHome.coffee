module.exports = (casper, scenario, step, c, p, t) ->
  casper.waitUntilVisible c.selectors.shopName, (->
    casper.then ->
      p casper, step
  ), ->
    t casper, step

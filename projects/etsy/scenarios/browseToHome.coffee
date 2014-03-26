module.exports = (casper, scenario, step, c, p, t) ->
  casper.waitUntilVisible c.selectors.shopName, (->
    casper.wait 500, ->
      p casper, step
  ), ->
    t casper, step

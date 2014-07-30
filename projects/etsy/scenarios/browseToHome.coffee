module.exports = (casper, c) ->
  casper.waitUntilVisible c.selectors.shopName, (->
    casper.then ->
      p casper, step
  ), ->
    t casper, step

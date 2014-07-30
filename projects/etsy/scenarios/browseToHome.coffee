module.exports = (casper, c) ->
  casper.waitUntilVisible c.selectors.shopName, (->
    casper.then ->
      c.pass casper, c.step
  ), ->
    c.fail casper, c.step

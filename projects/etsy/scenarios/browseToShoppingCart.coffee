module.exports = (casper, scenario, step, c, p, t) ->
  url = c.url+'/cart?ref=so_cart'
  casper.thenOpen url,( ->
    casper.waitForUrl url, ( ->
        casper.then ->
          p(casper, step)
    ), ->
      casper.then ->
        t(casper, step)
        return
  )
  return

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


module.exports = (casper, c) ->
  route = '/cart?ref=so_cart'
  casper.thenOpen c.proj.url+route,( ->
    casper.waitForUrl route, ( ->
        casper.then ->
          c.pass(casper, step)
          return
    ), ->
      casper.then ->
        this.echo(this.getCurrentUrl())
        c.fail(casper, step)
        return
  )
  return

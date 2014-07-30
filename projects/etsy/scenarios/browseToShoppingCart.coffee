module.exports = (casper, c) ->
  route = '/cart?ref=so_cart'
  casper.thenOpen c.url+route,( ->
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

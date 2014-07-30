module.exports = (casper, c) ->
  casper.thenOpen c.url+c.routes.searchFor,( ->
    casper.waitForUrl c.routes.searchFor, ( ->
        casper.then ->
          c.pass(casper, c.step)
          return
    ), ->
      casper.then ->
        this.echo(this.getCurrentUrl())
        c.fail(casper, c.step)
        return
  )
  return

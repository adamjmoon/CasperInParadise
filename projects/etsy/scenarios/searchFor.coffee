module.exports = (casper, c) ->
  casper.thenOpen c.proj.url+c.proj.routes.searchFor,( ->
    casper.waitForUrl c.proj.routes.searchFor, ( ->
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

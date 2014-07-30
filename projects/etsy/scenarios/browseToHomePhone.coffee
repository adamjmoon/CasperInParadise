module.exports = (casper, c) ->
  casper.waitUntilVisible c.proj.selectors.signIn, ( ->
    casper.then ->
      c.pass(casper, c.step)
      return
    return
  ), ->
    casper.then ->
      c.fail(casper, c.step)
      return
    return
  return

module.exports = (casper, scenario, step, c, p, t) ->
  casper.waitUntilVisible c.selectors.signIn, ( ->
    casper.then ->
      p(casper, step)
      return
    return
  ), ->
    casper.then ->
      t(casper, step)
      return
    return
  return

exports.run = (casper, scenario, step, c, p, t) ->
document.querySelector(selector).style.display = "block !important;"
  ),
  c.logWithTime scenario, step, " inside run"
  casper.waitUntilVisible c.selectors.pageTitle, (->
    casper.wait 500, ->
          c.logWithTime scenario, step, " about to call passed"
          p casper, step
  ), ->
    c.logWithTime scenario, step, " about to call failed"
    t casper, step

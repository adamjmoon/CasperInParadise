exports.run = (casper, scenario, step, c, p, t) ->
  
  # google search for 'bleacher report'
  c.logWithTime scenario, step, " inside run"
  casper.waitForSelector c.selectors.loginForm, (->
    casper.fill c.selectors.loginForm,
      Username: c.proj.username
      Password: c.proj.password
    , true
    casper.then ->
      casper.wait 3000, (->
        c.logWithTime scenario, step, " about to call passed"
        p casper, step
      ), ->
        c.logWithTime scenario, step, " about to call failed"
        t casper, step

  ), ->
    c.logWithTime scenario, step, " about to call failed"
    t casper, step

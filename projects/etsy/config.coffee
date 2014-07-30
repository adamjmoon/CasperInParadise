#    common project specific configurations
c = {}
c.name = 'etsy'
c.selectors = require './selectors.coffee'
c.routes = require './routes.coffee'
c.criteriaList = require './criteriaList.coffee'
c.url = 'https://www.etsy.com'

module.exports = c
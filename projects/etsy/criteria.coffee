filters = require '../../common/deviceTypeFilters.coffee'

#    common criteria list
criteria = {}
criteria["browseToHome"] =
  filter: filters.tablet_desktop
  bdd:
    GIVEN: 'Browsed to etsy store'
    THEN: 'store title should be visible'
  steps: ['browseToHome']

criteria["browseToHome.phone"] =
  filter: filters.phone
  bdd:
    GIVEN: 'Browsed to etsy store'
    THEN: 'store title should be visible'
  steps: ['browseToHome.phone']


module.exports = criteria

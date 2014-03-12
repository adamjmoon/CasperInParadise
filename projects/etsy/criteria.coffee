filters = require '../../common/deviceTypeFilters.coffee'

#    common criteria list
criteria = {}
criteria["browseToHome"] =
  filter: filters.tablet_desktop
  bdd:
    GIVEN: 'Browsed to etsy store'
    THEN: 'store title should be visible'
  steps: ['browseToHome']

criteria["browseToHome_phone"] =
  filter: filters.phone
  bdd:
    GIVEN: 'Browsed to etsy store'
    THEN: 'store title should be visible'
  steps: ['browseToHomePhone']
    
criteria["closeHeader"] =
  filter: filters.phone
  steps: ['browseToHome_phone','closeAppHeader']


module.exports = criteria

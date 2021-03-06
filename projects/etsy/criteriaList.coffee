filters = require '../../common/deviceTypeFilters.coffee'

#    common criteria list
c = {}
c["browseToHome"] =
  filter: filters.desktop
  bdd:
    GIVEN: 'Browsed to etsy store'
    THEN: 'store title should be visible'
  steps: ['browseToHome']

c["browseToHome_phone"] =
  filter: filters.phone
  bdd:
    GIVEN: 'Browsed to etsy store'
    THEN: 'store title should be visible'
  steps: ['browseToHomePhone']
    
c["searchForProduct"] =
  filter: filters.phone
  steps: ['browseToHome_phone','searchFor']
  
c["browseToCart"] =
  filter: filters.phone
  steps: ['browseToHome_phone','searchFor','browseToShoppingCart']


module.exports = c

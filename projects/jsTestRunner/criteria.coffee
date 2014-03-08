#    common criteria list
criteriaList = {}
criteriaList["runTests"] =
  bdd:
    GIVEN: 'Browsed to test runner page'
    THEN: 'Total Passed and Failed should be visible'
  steps: ['browseToTestRunner']


module.exports = criteriaList

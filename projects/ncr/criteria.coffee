#    common criteria list
criteriaList = {}
criteriaList.login =
  bdd:
    GIVEN: 'Browsed to login page'
    WHEN: "Enter Credentials and Submit Form"
    THEN: 'Should be on Home Page'
  steps: ['login']

criteriaList.showMenu =
  forDeviceType: "phone"
  steps: ['login','clickMenuLink']

module.exports = criteriaList

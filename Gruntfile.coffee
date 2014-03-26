module.exports = (grunt) ->
  async = require( "async" )
  fs = require('fs')
  colors = require('colors')
  _ = require('lodash')
  path = require('path')
  common = require "./common/config.coffee"
  stats = require "./common/stats.coffee"
  stats.failures = 1
  Sync = require( "sync" )

  argProject = grunt.option('proj')
  common.setProject(argProject)
  config = require "./projects/"+common.currentProject+"/config.coffee"

  argScenario = grunt.option('scenario')
  argDeviceType = grunt.option('deviceType')
  successCount = 0
  failedCount = 0
  commandTxt = './node_modules/.bin/casperjs casperTestRunner.coffee'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  # Configure Grunt
  grunt.initConfig
    clean: {options: {force: true}, all: ['results/'+common.currentProject+'/*', 'logs/*.log']}

  grunt.registerTask 'testAcceptanceCriteria', 'RUN ALL CRITERIA', () ->

    # Run in a fiber
    Sync ->
      criteriaRunner = require('./common/criteriaRunner.coffee')
      # Function.prototype.sync() interface is same as Function.prototype.call() - first argument is 'this' context
      try
        result = criteriaRunner.run.sync(null, common.currentProject, argDeviceType, argScenario)
      catch e
        console.error e  # something went wrong
      return
    return
    


  grunt.registerTask 'default', ['clean', 'testAcceptanceCriteria']





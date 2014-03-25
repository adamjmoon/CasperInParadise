module.exports = (grunt) ->
  async = require( "async" )
  fs = require('fs')
  colors = require('colors')
  _ = require('lodash')
  path = require('path')
  criteriaRunner = require('./common/criteriaRunner.coffee')
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
    clean: {options: {force: true}, all: ['results', 'logs']}

  grunt.registerTask 'testAcceptanceCriteria', 'RUN ALL CRITERIA', () ->
    asyncFunction = (a, b, callback) ->
      process.nextTick ->
        callback null, a + b
        return

      return

    # Run in a fiber
    Sync ->
      # Function.prototype.sync() interface is same as Function.prototype.call() - first argument is 'this' context
      result = asyncFunction.sync(null, 2, 3)
      console.log result # 5

      work = criteriaRunner.runInParallel.sync(null, common.currentProject, argDeviceType, argScenario)
      console.log work
      async.parallel.sync null, work, callback

    return this.async()


  grunt.registerTask 'default', ['clean', 'testAcceptanceCriteria']





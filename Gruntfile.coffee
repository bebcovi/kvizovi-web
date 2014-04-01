'use strict'

module.exports = (grunt) ->

  require('load-grunt-tasks')(grunt)

  grunt.initConfig

    watch:
      latex:
        files: ['doc/*.tex']
        tasks: ['latex']


    svgmin:
      dist:
        files: [
          expand: true
          cwd: 'vendor/assets/images/icons/svg/'
          src: '{,*/}*.svg'
          dest: 'vendor/assets/images/icons/svg/'
        ]


    latex:
      options:
        outputDirectoy: 'doc'
      dist:
        src: ['doc/test.tex']


  grunt.registerTask 'build', ['svgmin']

  grunt.registerTask 'docs', (target) ->
    grunt.task.run ['latex']
    grunt.task.run ['watch'] if target is 'watch'

  grunt.registerTask 'default', ['build']

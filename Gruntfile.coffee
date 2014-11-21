module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-coffeelint')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.initConfig
    watch:
      coffee:
        files: 'src/*.coffee'
        tasks: ['coffeelint', 'coffee:compile']

    coffee:
      compile:
        expand: true
        flatten: true
        cwd: "#{__dirname}/src/"
        src: ['*.coffee']
        dest: 'build/'
        ext: '.js'

    coffeelint:
      app: ['src/*.coffee'],

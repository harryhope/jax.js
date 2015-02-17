module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  grunt.initConfig
    watch:
      coffee:
        files: 'src/*.coffee'
        tasks: 'build'

    coffee:
      compile:
        expand: true
        flatten: true
        cwd: "#{__dirname}/src/"
        src: ['*.coffee']
        dest: 'build/'
        ext: '.js'

    uglify:
      options:
        mangle: no
      target:
        files: 'build/jax.min.js': ['build/jax.js']

    coffeelint:
      app: ['src/*.coffee']

  grunt.registerTask 'build', ['coffeelint', 'coffee:compile', 'uglify']

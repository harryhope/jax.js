module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  grunt.initConfig
    watch:
      coffee:
        files: 'src/*.coffee'
        tasks: 'build'

    coffee:
      compile:
        files:
          'build/jax.js': 'src/jax.coffee'
      compileSpec:
        files:
          'spec/jax-spec.js': 'spec/jax-spec.coffee'

    coffeelint:
      build: ['src/*.coffee']

    uglify:
      options:
        mangle: no
      target:
        files: 'build/jax.min.js': ['build/jax.js']

    jasmine:
      jax:
        src: 'build/jax.min.js'
        options:
          specs: 'spec/jax-spec.js'
          vendor: ['node_modules/jasmine-ajax/lib/mock-ajax.js']

    clean:
      spec: ['spec/jax-spec.js']

  grunt.registerTask 'build', ['coffeelint', 'coffee:compile', 'uglify']
  grunt.registerTask 'test', ['coffee:compileSpec', 'jasmine', 'clean:spec']

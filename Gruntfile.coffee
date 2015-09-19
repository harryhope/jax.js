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
      build: ['src/*.coffee', 'spec/*.coffee']
      options:
        arrow_spacing: {level: 'error'}
        ensure_comprehensions: {level: 'error'}
        no_unnecessary_double_quotes: {level: 'error'}
        no_trailing_whitespace: {level: 'error'}
        no_empty_param_list: {level: 'error'}
        spacing_after_comma: {level: 'error'}
        no_stand_alone_at: {level: 'error'}
        space_operators: {level: 'error'}
        indentation:
          value: 2
          level: 'error'
        cyclomatic_complexity:
          value: 36
          level: 'error'
        max_line_length:
          value: 120,
          level: 'error'
          limitComments: yes

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
  grunt.registerTask 'test', [
    'coffeelint',
    'clean:spec',
    'coffee:compileSpec',
    'jasmine',
    'clean:spec'
  ]

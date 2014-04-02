module.exports = (grunt) ->
  pkg = grunt.file.readJSON 'package.json'
  banner = [
    '/**',
    ' * @license',
    ' * <%= pkg.name %> - v<%= pkg.version %>',
    ' * Copyright © 2014-2014, Sebastiaan Hilbers',
    ' * <%= pkg.homepage %>',
    ' *',
    ' * Compiled: <%= grunt.template.today("yyyy-mm-dd") %>',
    ' *',
    ' * <%= pkg.name %> is licensed under the <%= pkg.license %> License.',
    ' * <%= pkg.licenseUrl %>',
    ' */',
  ].join '\n'

  # 1. Project configuration.
  grunt.initConfig
    pkg: pkg

    dirs:
      dist: 'build'
      docs: 'docs'
      src: 'src'
      test: 'tests'

    files:
      dev: '<%= dirs.dist %>/porcupine.js'
      dist: '<%= dirs.dist %>/porcupine.min.js'
      sourceMap: '<%= dirs.dist %>/porcupine.min.map'
      main: '<%= dirs.src %>/Core.coffee'

    browserify:
      options:
        standalone: 'porcupine'
      dev:
        src: '<%= files.main %>'
        dest: '<%= files.dev %>'

    concat:
      options:
        stripBanners: yes
        banner: banner
      dev:
        src: ['<%= dirs.dist %>/**/*.js']
        dest: '<%= files.dev %>'

    clean:
      build:
        src: ['build']

    uglify:
      options:
        banner: banner
        mangle: yes
        report: 'min'
        sourceMap: yes
        sourceMapName: '<%= files.sourceMap %>'
      dist:
        files:
          '<%= files.dist %>': '<%= files.dev %>'

    coffeelint:
      app: ['**/*.coffee']

    coffee:
      app:
        expand: yes
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'build'
        ext: '.js'

    readme_generator:
      build:
        options:
          # Task-specific options go here.
          # detailed explanation is under options
          # Default options:
          readme_folder: '_readme'
          output: 'build/README.md'
          table_of_contents: yes
          toc_extra_links: [],
          generate_changelog: no
          banner: 'banner.md'
          has_travis: no
          generate_footer: yes
          generate_title: yes
          package_title: null
          package_name: null
          package_desc: null
          informative: yes
        order:
          'intro.md': 'intro'
          'installation.md': 'Installation'

    watch:
      app:
        files: '**/*.coffee'
        tasks: ['build:dev']

    yuidoc:
      compile:
        name: '<%= pkg.name %>'
        description: '<%= pkg.description %>'
        version: 'v<%= pkg.version %>'
        url: '<%= pkg.homepage %>'
        options:
          paths: '<%= dirs.src %>'
          exclude: 'vendor'
          outdir: '<%= dirs.docs %>'

    mocha:
      dist:
        src: ['tests/unit/runner.html']
        options:
          mocha:
            ignoreLeaks: no
          log: yes
          reporter: 'Spec'
          run: yes

  # 2. Load the grunt plugins
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-yuidoc'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-readme-generator'
  grunt.loadNpmTasks 'grunt-mocha'

  # 3. Tell grunt what to do when called

  # build tasks
  grunt.registerTask 'build:dev', [
    'clean:build'
    'coffee:app'
    'readme_generator:build'
    #'browserify:dev'
    'concat:dev'
  ]
  grunt.registerTask 'build:dist', [
    'build:dev'
    'uglify:dist'
  ]
  grunt.registerTask 'build', ['build:dist']

  # test tasks
  grunt.registerTask 'test', ['mocha:dist']

  # default task
  grunt.registerTask 'default', [
    'coffeelint:app'
    'build'
  ]

  # misc tasks
  grunt.registerTask 'dev', [
    'build'
    'watch:app'
  ]
  grunt.registerTask 'docs', ['yuidoc:compile']

module.exports = (grunt) ->
  # 1. Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    clean:
      build:
        src: ['build']

    coffee:
      app:
        expand: yes
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'build'
        ext: '.js'

    readme_generator:
      porcupine:
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
          generate_title: true
          package_title: null
          package_name: null
          package_desc: null
          informative: true
        order:
          # Title of the piece and the File name goes here
          # 'Filename' : 'Title'
          'intro.md': 'intro'
          'installation.md': 'Installation'
         # 'usage.md': 'Usage'
         # 'options.md': 'Options'
         # 'example.md': 'Example'
         # 'output.md': 'Example Output'
         # 'building-and-testing.md': 'Building and Testing'
         # 'legal.md': 'Legal Mambo Jambo'

    watch:
      app:
        files: '**/*.coffee'
        tasks: ['coffee']

  # 2. Load the grunt plugins
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-readme-generator'

  # 3. Tell grunt what to do when called
  grunt.registerTask 'build', [
    'clean:build'
    'coffee'
    'readme_generator:porcupine'
  ]

  # default task
  grunt.registerTask 'default', 'build'
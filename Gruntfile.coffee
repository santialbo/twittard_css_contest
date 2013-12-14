LIVERELOAD_PORT = 35728

lrSnippet = require('connect-livereload')({port: LIVERELOAD_PORT})
mountFolder = (connect, dir) -> connect.static(require('path').resolve(dir))

module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig

    less:
      dist:
        files:
          'style.css': ['less/main.less']

    clean:
      dist:
        files: [
            src: ['dist']
        ]

    watch:
      less:
        files: 'less/*'
        tasks: 'less:dist'
      livereload:
        options:
          livereload: LIVERELOAD_PORT
        tasks: []
        files: ['style.css', 'index.html']

    connect:
      options:
        port: 8090
        hostname: 'localhost'
      livereload:
        options:
          middleware: (connect) -> [
            lrSnippet,
            mountFolder(connect, '.'),
          ]

    open:
      server:
        url: 'http://<%= connect.options.hostname %>:<%= connect.options.port %>'

  grunt.registerTask 'default', ['clean', 'less']

  grunt.registerTask 'server', ['default', 'connect', 'open', 'watch']

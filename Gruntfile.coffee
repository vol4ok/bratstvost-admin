module.exports = (grunt) ->
  grunt.loadNpmTasks("grunt-contrib-coffee")
  grunt.loadNpmTasks("grunt-contrib-copy")
  grunt.loadNpmTasks("grunt-contrib-less")
  grunt.loadNpmTasks("grunt-contrib-concat")
  grunt.loadNpmTasks("grunt-contrib-cssmin")
  grunt.loadNpmTasks("grunt-contrib-uglify")
  grunt.loadNpmTasks("grunt-contrib-clean")
  grunt.loadNpmTasks("grunt-contrib-watch")
  grunt.loadNpmTasks('grunt-bump')
  
  grunt.initConfig

    ### ----------------------- ###
    ### ******** WATCH ******** ###
    ### ----------------------- ###

    watch: 
      less:
        files: 'styles/**/*.less'
        tasks: ['styles']
      coffee:
        files: 'scripts/**/*.coffee'
        tasks: ["coffee:client", "concat:app"]

    ### ------------------------ ###
    ### ******** COFFEE ******** ###
    ### ------------------------ ###

    coffee:
      client:
        files:
          "temp/js/core.js":                           "scripts/core.coffee"
          "temp/js/admin-app.js":                      "scripts/admin-app.coffee"
          "temp/js/factories.js":                       "scripts/factories/*.coffee"
          "temp/js/services.js":                       "scripts/services/*.coffee"
          "temp/js/controllers.js":                    "scripts/controllers/*.coffee"
          "temp/js/directives.js":                     "scripts/directives/*.coffee"
      server:
        options:
          bare: yes
        files:
          "dist/web.js":            "index.coffee"
          "dist/models/event.js":   "models/event.coffee"
          "dist/models/notice.js":  "models/notice.coffee"
          "dist/models/news.js":    "models/news.coffee"
          "dist/models/member.js":    "models/member.coffee"
          "dist/models/video.js":    "models/video.coffee"


    ### ---------------------- ###
    ### ******** LESS ******** ###
    ### ---------------------- ###

    less: 
      bootstrap:
        options:
          paths: [
            "styles"
            "bower_components"
          ]
        files:
          "temp/css/bootstrap.css": "styles/shared.less"

      styles: 
        options:
          paths: [
            "styles"
            "bower_components"
          ]
        files:
          "temp/css/admin-app.css": "styles/admin-app.less"


    ### ------------------------ ###
    ### ******** CONCAT ******** ###
    ### ------------------------ ###

    concat:
      core:
        src: [
          "bower_components/jquery/dist/jquery.js"
          "bower_components/lodash/dist/lodash.js"
          "bower_components/angular/angular.js"
          "bower_components/angular-route/angular-route.js"
          "bower_components/angular-sanitize/angular-sanitize.js"
          "bower_components/angular-bootstrap/ui-bootstrap-tpls.js"
          "bower_components/bootstrap/dist/js/bootstrap.js"
          "bower_components/jquery-ui/jquery-ui.js"
          "bower_components/moment/min/moment.min.js"
          "bower_components/moment/min/langs.min.js"
          "bower_components/node-uuid/uuid.js"
          "bower_components/angular-uuid4/angular-uuid4.js"
          "bower_components/marked/lib/marked.js"
          "bower_components/select2/select2.js"
          "bower_components/angular-ui-select2/src/select2.js"
          "bower_components/summernote/dist/summernote.js"
          "bower_components/summernote/lang/summernote-ru-RU.js"
          "bower_components/angular-summernote/dist/angular-summernote.js"
        ]
        dest: "public/js/core.js"

      app:
        src: [
          "temp/js/core.js"
          "temp/js/admin-app.js"
          "temp/js/factories.js"
          "temp/js/services.js"
          "temp/js/controllers.js" 
          "temp/js/directives.js" 
        ]
        dest: "public/js/app.js"

      dist:
        src: [
          "bower_components/jquery/dist/jquery.min.js"
          "bower_components/lodash/dist/lodash.min.js"
          "bower_components/angular/angular.min.js"
          "bower_components/angular-route/angular-route.min.js"
          "bower_components/angular-sanitize/angular-sanitize.min.js"
          "bower_components/angular-bootstrap/ui-bootstrap-tpls.min.js"
          "bower_components/bootstrap/dist/js/bootstrap.min.js"
          "bower_components/jquery-ui/jquery-ui.js"
          "bower_components/moment/min/moment.min.js"
          "bower_components/moment/min/langs.min.js"
          "bower_components/node-uuid/uuid.js"
          "bower_components/angular-uuid4/angular-uuid4.js"
          "bower_components/marked/lib/marked.js"
          "bower_components/select2/select2.js"
          "bower_components/angular-ui-select2/src/select2.js"
          "bower_components/summernote/dist/summernote.min.js"
          "bower_components/summernote/lang/summernote-ru-RU.js"
          "bower_components/angular-summernote/dist/angular-summernote.min.js"
        ]
        dest: "temp/js/core.js"

      styles:
        src: [
          "styles/core/bratstvost-icon-font.css"
          "bower_components/jquery-ui/themes/flick/jquery-ui.css"
          "bower_components/summernote/dist/summernote.css"
          "temp/css/bootstrap.css"
          "temp/css/admin-app.css"
          "bower_components/bootstrap/dist/css/bootstrap.min.css"
        ]
        dest: "public/css/styles.css"

    ### ---------------------- ###
    ### ******** COPY ******** ###
    ### ---------------------- ###

    copy:
      dist:
        files: [
            expand: yes
            cwd: "public/img/"
            src: "**"
            dest: "dist/public/img/"
          ,
            expand: yes
            cwd: "public/fonts/"
            src: "**"
            dest: "dist/public/fonts/"
          ,
            expand: yes
            cwd: "public/"
            src: "favicon.ico"
            dest: "dist/public"
            filter: 'isFile'
          ,
            expand: yes
            src: ["package.json", "Procfile", "nginx.conf"]
            dest: "dist"
            filter: 'isFile' 
          ,
            expand: yes
            cwd: "views/"
            src: "**"
            dest: "dist/views"
        ]

    ### ------------------------ ###
    ### ******** CSSMIN ******** ###
    ### ------------------------ ###

    cssmin:
      dist:
        options:
          keepSpecialComments: 0
        files:
          "dist/public/css/styles.css": "public/css/styles.css"


    ### ------------------------ ###
    ### ******** UGLIFY ******** ###
    ### ------------------------ ###

    uglify:
      dist:
        options:
          mangle: false
        files:
          'dist/public/js/core.js': ["temp/js/core.js"]
          'dist/public/js/app.js':  ["public/js/app.js"]


    ### ----------------------- ###
    ### ******** CLEAN ******** ###
    ### ----------------------- ###

    clean:
      dist: [
        "dist/models"
        "dist/public"
        "dist/views"
        "dist/package.json"
        "dist/Procfile"
        "dist/web.js"
        "dist/nginx.conf"
      ]
      temp: ["temp"]
      pub: ["public/js/*.js", "public/css/*.css"]


  grunt.registerTask "bootstrap", ["less:bootstrap"]
  grunt.registerTask "styles", ["less:bootstrap", "less:styles", "concat:styles"]
  grunt.registerTask "core", ["concat:core"]
  grunt.registerTask "default", ["styles", "coffee:client", "concat:app"]
  grunt.registerTask "dist", ["styles", "coffee", "concat:dist", "cssmin", "uglify", "copy"]
  grunt.registerTask "build", ["core", "default", "dist"]
  grunt.registerTask "rebuild", ["clean", "core", "default", "dist"]

  grunt.registerTask "dev", ["clean", "styles", "coffee", "concat:core", "concat:app", "copy"]

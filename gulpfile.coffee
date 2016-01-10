gulp = require('gulp')
rename = require('gulp-rename')
concatCss = require('gulp-concat-css')
minifyCSS = require('gulp-minify-css')
plumber = require('gulp-plumber')
haml = require('gulp-ruby-haml')
coffee = require('gulp-coffee')
sourcemaps = require('gulp-sourcemaps')
compass = require('gulp-compass')
imagemin = require('gulp-imagemin')
pngquant = require('imagemin-pngquant')
uncss = require('gulp-uncss')
uglify = require('gulp-uglify')
glob = require('glob')
htmlmin = require('gulp-htmlmin')
zip = require('gulp-zip')
spritesmith = require('gulp.spritesmith')
slim = require('gulp-slim')
sass = require('gulp-sass')
stylus = require('gulp-stylus')
prefix = require('gulp-autoprefixer')
please = require('gulp-pleeease')
nodemon = require('gulp-nodemon')
browserSync = require('browser-sync')
runSequence = require 'run-sequence'
gulp.task 'coffee',->
  gulp.src('./client/app/javascripts/**/*.coffee')
  .pipe(plumber(errorHandler : (error,file) ->
    console.log error.message
    @emit 'end'
  ))
  .pipe(sourcemaps.init())
  .pipe(coffee(bare : false))
#  .pipe(uglify())
  .pipe(sourcemaps.write('./'))
  .pipe gulp.dest('./client/app/javascripts/')
gulp.task 'imagemin',->
  gulp.src('./client/app/images/**/*').pipe(imagemin(
    progressive : true
    svgoPlugins : [{removeViewBox : false}]
    use : [pngquant()])).pipe gulp.dest('./client/app/images')
gulp.task 'watchConsole',->
  exec = require('child_process').exec
  watch = require('gulp-watch')
  watch './client/app/images/**/*.{jpg,jpeg,png,gif}',->
    exec 'chmod 755 -R ./app/images'
gulp.task 'sass',->
  gulp.src('./client/app/stylesheets/**/*.scss')
  .pipe(plumber(errorHandler : (error,file) ->
    console.log error.message
    @emit 'end'
  ))
  .pipe(sourcemaps.init())
  .pipe(sass())
  .pipe(sourcemaps.write('./'))
  .pipe gulp.dest('./client/app/stylesheets')
gulp.task 'please',->
  gulp.src('./client/app/stylesheets/**/*.css')
  .pipe(plumber(errorHandler : (error,file) ->
    console.log error.message
    @emit 'end'
  ))
  .pipe(please(
    'minifier' : false
    'browsers' : [
      'last 6 versions'
      'Android 2.3'
      'ie 7'
      'ie 8'
      'ie 9'
      'ie 10'
      'ie 11'
    ]
    'autoprefixer' : true
    'filters' : true
    'oldIE' : true
    'rem' : true
    'pseudoElements' : true
    'opacity' : true
    'import' : true
    'mqpacker' : true
    'next' : true,
  ))
  .pipe gulp.dest('./client/app/stylesheets')
gulp.task 'sprite',->
  spriteData = gulp.src('./client/app/images/sprite/*.*').pipe(spritesmith(
    imgName : '../images/sprite.png'
    cssName : '_sprite.scss'
    padding : 2))
  spriteData.img.pipe gulp.dest('./client/app/images/')
  spriteData.css.pipe gulp.dest('./client/app/stylesheets/')
gulp.task 'watch',->
  gulp.watch './client/app/stylesheets/**/*.scss',['sass']
  gulp.watch './client/app/stylesheets/**/*.scss',['sprite']
  gulp.watch './client/app/javascripts/**/*.coffee',['coffee']
#  gulp.watch './client/app/stylesheets/**/*.css',['please']
gulp.task 'default',[
  'sass'
  'sprite'
  'coffee'
  'watch'
]


#admin
gulp.task 'stylus:admin',->
  gulp.src('./client/app/admin/styles/application.styl')
  .pipe(plumber(errorHandler : (error,file) ->
    console.log error.message
    @emit 'end'
  ))
  .pipe(stylus(
    'include css' : true
    sourcemap :
      inline : true
      sourceRoot : '.'
      basePath : './client/app/admin/styles'
  ))
  .pipe(please(
    'minifier' : false
    "autoprefixer" : {
      'browsers' : [
        'last 6 versions'
        'Android 4'
        'ie 9'
        'ie 10'
        'ie 11'
      ]
    },
    'filters' : true
    'oldIE' : true
    'rem' : true
    'pseudoElements' : true
    'opacity' : true
    'import' : true
    'mqpacker' : true
    'next' : true,
    preserveHacks : true,
    removeAllComments : true
    sourcemaps : true
  ))
  .pipe gulp.dest('./client/app/admin/styles')
gulp.task 'sprite:admin',->
  spriteData = gulp.src('./client/app/admin/images/sprite/*.*').pipe(spritesmith(
    imgName : './sprite.png'
    cssName : '_sprite.styl'
    padding : 2))
  spriteData.img.pipe gulp.dest('./client/app/admin/images/')
  spriteData.css.pipe gulp.dest('./client/app/admin/styles/utilities/')
#gulp.task 'jade:admin',->
##  data = {}
##  data.images = {}
##  data.filters = require './app/json/filters.json'
#  #  data.images.categoriesImages = scandir('./app/images/categories_images','names')
#  gulp.src('./client/app/admin/jade/pages/*.jade')
#  .pipe(plumber(errorHandler : (error,file) ->
#      console.log error.message
#      @emit 'end'
#    ))
#  .pipe(jade(
#      pretty : true
#      locals : data
#    ))
#  .pipe gulp.dest('./app/')
gulp.task 'watch:admin',->
  gulp.watch './client/app/admin/styles/**/*.styl',['stylus:admin']
  gulp.watch './client/app/admin/styles/**/_sprite.slyl',['sprite:admin']
#  gulp.watch './app/scripts/**/*.coffee',['coffee']
#  gulp.watch './app/jade/**/*.jade',['jade']
#  gulp.watch './app/json/**/*.json',['jade']
#  gulp.watch './app/images/categories_images/**/*',['jade']
gulp.task 'default:admin',[
  'sprite:admin'
  "stylus:admin"
#  'sass'
#  'coffee'
#  'jade'
  'watch:admin'
#  'connect'
]

reload = () ->
  browserSync.reload({stream : false})

gulp.task 'browser-sync',() ->
  browserSync({
    port : 8080,
    browser : ['google-chrome']
    open : false
    proxy : 'http://localhost:3000',
    files : ["server/views/**"]
    nodeArgs : ['--debug8080']
  });
  gulp.watch('server/views/**').on('change',browserSync.reload);


###gulp.task 'nodemon',(cb) ->
  nodemon
    script : 'server/server.js',
    watch : ['server/','common/'],
    ext : "js json"
  .once 'start',() ->
    runSequence "browser-sync"
  .on 'restart',() ->
    setTimeout(() ->
      console.log('restart')
      browserSync.reload(
        stream : false
      )
    ,500)###
gulp.task 'nodemon',(cb) ->
  nodemon
    script : 'server/server.js',
    watch : ['server/','common/'],
    ext : "js json"
    stdout: false
  .once 'start',() ->
    runSequence "browser-sync"
  .on 'readable',() ->
    this.stdout.on 'data',(chunk) ->
      if (/^Web server listening at/.test(chunk))
        reload()
      process.stdout.write(chunk)
    this.stderr.on 'data',(chunk) ->
      process.stderr.write(chunk);


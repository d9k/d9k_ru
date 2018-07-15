var gulp    = require('gulp'),
    coffee  = require('gulp-coffee'),
    babel   = require('gulp-babel'),
    sourcemaps = require('gulp-sourcemaps'),
    gutil   = require('gulp-util');

config = {
    coffeePath: './themes/default/coffee',
    //es6Path : './es6',
    staticDir: './themes/default'
};

gulp.task('coffee', function(){
    gulp.src(config.coffeePath + '/**/*.coffee')
    //gulp.src(config.coffeePath + '/*.coffee')
        // bare option: see http://coffeescript.org/#lexical-scope
        //.pipe(sourcemaps.init())
        .pipe(coffee({
          "inline-map": true, //doesn't work
          //bare: true,
          transpile: {
            presets: [
              // Without any configuration options, babel-preset-env behaves exactly the same as babel-preset-latest (or babel-preset-es2015, babel-preset-es2016, and babel-preset-es2017 together).
              'env',
            ],
            plugins: [
              ["transform-react-jsx", {
                "pragma": "m" // default pragma is React.createElement
                //,useBuiltIns: true
              }]
            ],
          }
        }))//.on('error', gutil.log))
        //.pipe(coffee({bare: true}))//.on('error', gutil.log))
        //.pipe(sourcemaps.write('.'))
        //.pipe(gulp.dest(config.es6Path));
        .pipe(gulp.dest(config.staticDir + '/js'));
});

//gulp.task('es6', function () {
//	gulp.src(
//    config.es6Path + '/**/*.js'
//  )
//	.pipe(babel({
//		presets: [
//      // Without any configuration options, babel-preset-env behaves exactly the same as babel-preset-latest (or babel-preset-es2015, babel-preset-es2016, and babel-preset-es2017 together).
//      'env',
//
//    //'es2015', 'stage-0'//, 'react'
//    //, 'es2016', 'es2017'
//    ],
//    plugins: [
//      ["transform-react-jsx", {
//        "pragma": "m" // default pragma is React.createElement
//        //,useBuiltIns: true
//      }]
//    ],
//    // plugins: ['transform-runtime'],
//		//sourceRoot: 'src',
////    sourceRoot: src.babelSourceRoot,
//		//sourceMap: true
//	}))
//	.pipe(gulp.dest(config.staticDir + '/js'));
//});

// Rerun the task when a file changes
gulp.task('watch', function() {
    gulp.watch(config.coffeePath + '/**/*.coffee', ['coffee']);
    //gulp.watch(config.es6Path + '/**/*.es6', ['es6']);
 });


//gulp.task('default', ['coffee', 'es6']);
gulp.task('default', ['coffee']);

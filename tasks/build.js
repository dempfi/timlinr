'use strict';

var pathUtil = require('path');
var Q        = require('q');
var gulp     = require('gulp');
var rollup   = require('rollup');
var stylus   = require('gulp-stylus');
var coffee   = require('gulp-coffee');
var jetpack  = require('fs-jetpack');
var concat   = require('gulp-concat');
var nib      = require('nib');

var utils    = require('./utils');
var generateSpecsImportFile = require('./generate_specs_import');

var projectDir = jetpack;
var srcDir = projectDir.cwd('./app');
var destDir = projectDir.cwd('./build');

var paths = {
    copyFromAppDir: [
        './node_modules/**',
        './vendor/**'
    ],
}

// -------------------------------------
// Tasks
// -------------------------------------

gulp.task('clean', function(callback) {
    return destDir.dirAsync('.', { empty: true });
});

var copyTask = function () {
  return Q.all([
    projectDir.copyAsync('app', destDir.path(), {
       overwrite: true,
       matching: paths.copyFromAppDir
    }),
    projectDir.copyAsync('app/assets', destDir.path(), {
       overwrite: true,
       matching: ['*']
    })
  ]);

}

gulp.task('copy', ['clean'], copyTask);
gulp.task('copy-watch', copyTask);


var bundle = function (src, dest) {
    var deferred = Q.defer();

    rollup.rollup({
        entry: src
    }).then(function (bundle) {
        var jsFile = pathUtil.basename(dest);
        var result = bundle.generate({
            format: 'iife',
            sourceMap: true,
            sourceMapFile: jsFile,
        });
        return Q.all([
            destDir.writeAsync(dest, result.code + '\n//# sourceMappingURL=' + jsFile + '.map'),
            destDir.writeAsync(dest + '.map', result.map.toString()),
        ]);
    }).then(function () {
        deferred.resolve();
    }).catch(function (err) {
        console.error(err);
    });

    return deferred.promise;
};

var bundleApplication = function () {
    return Q.all([
        bundle(srcDir.path('background.js'), destDir.path('background.js')),
        bundle(srcDir.path('app.js'), destDir.path('app.js')),
    ]);
};

var bundleSpecs = function () {
    generateSpecsImportFile().then(function (specEntryPointPath) {
        return Q.all([
            bundle(srcDir.path('background.js'), destDir.path('background.js')),
            bundle(specEntryPointPath, destDir.path('spec.js')),
        ]);
    });
};

var bundleTask = function () {
    return gulp.src('app/*.js')
    .pipe(gulp.dest(destDir.path()))

};
gulp.task('bundle', ['clean'], bundleTask);
gulp.task('bundle-watch', bundleTask);


var stylusTask = function () {
    return gulp.src('app/**/*.styl')
    .pipe(stylus({use: nib(), import : ['nib']}))
    .pipe(concat('app.css'))
    .pipe(gulp.dest(destDir.path()));
};
gulp.task('stylus', ['clean'], stylusTask);
gulp.task('stylus-watch', stylusTask);

var coffeeTask = function () {
    return gulp.src('app/**/*.coffee')
    .pipe(coffee({bare: true}))
    .pipe(gulp.dest(destDir.path()));
};
gulp.task('coffee', ['clean'], coffeeTask);
gulp.task('coffee-watch', coffeeTask);


gulp.task('finalize', ['clean'], function () {
    var manifest = srcDir.read('package.json', 'json');
    // Add "dev" or "test" suffix to name, so Electron will write all data
    // like cookies and localStorage in separate places for each environment.
    switch (utils.getEnvName()) {
        case 'development':
            manifest.name += '-dev';
            manifest.productName += ' Dev';
            break;
        case 'test':
            manifest.name += '-test';
            manifest.productName += ' Test';
            break;
    }
    destDir.write('package.json', manifest);

    var configFilePath = projectDir.path('config/env_' + utils.getEnvName() + '.json');
    destDir.copy(configFilePath, 'env_config.json');
});


gulp.task('watch', function () {
    gulp.watch('app/**/*.js', ['bundle-watch']);
    gulp.watch(paths.copyFromAppDir, { cwd: 'app' }, ['copy-watch']);
    gulp.watch('app/**/*.coffee', ['coffee-watch']);
    gulp.watch('app/**/*.styl', ['stylus-watch']);
});


gulp.task('build', ['bundle', 'stylus', 'coffee', 'copy', 'finalize']);

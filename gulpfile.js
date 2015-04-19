"use strict";

var gulp = require("gulp");
var plumber = require("gulp-plumber");
var purescript = require("gulp-purescript");
var jsvalidate = require("gulp-jsvalidate");
var run = require("gulp-run");

var paths = [
  "src/**/*.purs",
  "bower_components/purescript-*/src/**/*.purs"
];

gulp.task("make", function() {
  return gulp.src(paths)
    .pipe(plumber())
    .pipe(purescript.pscMake());
});

gulp.task("jsvalidate", ["make"], function () {
  return gulp.src("output/**/*.js")
    .pipe(plumber())
    .pipe(jsvalidate());
});

var docTasks = [];

var docTask = function(name) {
  var taskName = "docs-" + name.toLowerCase();
  gulp.task(taskName, function () {
    return gulp.src("src/" + name.replace(/\./g, "/") + ".purs")
      .pipe(plumber())
      .pipe(purescript.pscDocs())
      .pipe(gulp.dest("docs/" + name + ".md"));
  });
  docTasks.push(taskName);
};

["Data.Foreign", "Data.Foreign.Class", "Data.Foreign.Index",
 "Data.Foreign.Keys", "Data.Foreign.Null", "Data.Foreign.NullOrUndefined",
 "Data.Foreign.Undefined"].forEach(docTask);

gulp.task("docs", docTasks);

var exampleTasks = [];

var exampleTask = function(name) {
  var taskName = "example-" + name.toLowerCase();
  gulp.task(taskName, function() {
    return gulp.src(["examples/" + name + ".purs"].concat(paths))
      .pipe(plumber())
      .pipe(purescript.psc({ main: "Example." + name }))
      .pipe(run("node"));
  });
  exampleTasks.push(taskName);
};

["Applicative", "Complex", "JSONArrays", "JSONSimpleTypes", "MaybeNullable",
 "Nested", "Objects", "ParseErrors", "Union"].forEach(exampleTask);

gulp.task("examples", exampleTasks);

gulp.task("default", ["jsvalidate", "docs", "examples"]);

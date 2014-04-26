module.exports = function(grunt) {

  "use strict";

  grunt.initConfig({ 
  
    libFiles: [
      "src/**/*.purs",
      "bower_components/purescript-*/src/**/*.purs",
    ],
    
    clean: ["output"],
  
    pscMake: {
        all: {
            src: ["examples/**/*.purs", "<%=libFiles%>"],
        }
    },
    dotPsci: ["<%=libFiles%>"]

  });

  grunt.loadNpmTasks("grunt-contrib-clean");
  grunt.loadNpmTasks("grunt-purescript");
  
  grunt.registerTask("make", ["pscMake", "dotPsci"]);
  grunt.registerTask("default", ["make"]);
};

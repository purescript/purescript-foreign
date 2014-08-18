module.exports = function(grunt) {

  "use strict";

  grunt.initConfig({ 
  
    libFiles: [
      "src/**/*.purs",
      "bower_components/purescript-*/src/**/*.purs",
    ],
    
    clean: ["output"],
  
    pscMake: ["<%=libFiles%>"],
    dotPsci: ["<%=libFiles%>"],
    docgen: {
        readme: {
            src: "src/**/*.purs",
            dest: "docs/Module.md"
        }
    },
    
    psc: {
      exampleNested: {
        options: { main: "Nested" },
        src: ["examples/Nested.purs", "<%=libFiles%>"],
        dest: "tmp/Nested.js"
      },
      exampleApplicative: {
        options: { main: "Applicative" },
        src: ["examples/Applicative.purs", "<%=libFiles%>"],
        dest: "tmp/Applicative.js"
      },
      exampleComplex: {
        options: { main: "Complex" },
        src: ["examples/Complex.purs", "<%=libFiles%>"],
        dest: "tmp/Complex.js"
      },
      exampleJSONArrays: {
        options: { main: "JSONArrays" },
        src: ["examples/JSONArrays.purs", "<%=libFiles%>"],
        dest: "tmp/JSONArrays.js"
      },
      exampleJSONSimpleTypes: {
        options: { main: "JSONSimpleTypes" },
        src: ["examples/JSONSimpleTypes.purs", "<%=libFiles%>"],
        dest: "tmp/JSONSimpleTypes.js"
      },
      exampleMaybeNullable: {
        options: { main: "MaybeNullable" },
        src: ["examples/MaybeNullable.purs", "<%=libFiles%>"],
        dest: "tmp/MaybeNullable.js"
      },
      exampleObjects: {
        options: { main: "Objects" },
        src: ["examples/Objects.purs", "<%=libFiles%>"],
        dest: "tmp/Objects.js"
      },
      exampleParseErrors: {
        options: { main: "ParseErrors" },
        src: ["examples/ParseErrors.purs", "<%=libFiles%>"],
        dest: "tmp/ParseErrors.js"
      }
    },

    execute: {
      exampleNested: {
        src: "tmp/Nested.js"
      },
      exampleApplicative: {
        src: "tmp/Applicative.js"
      },
      exampleComplex: {
        src: "tmp/Complex.js"
      },
      exampleJSONArrays: {
        src: "tmp/JSONArrays.js"
      },
      exampleJSONSimpleTypes: {
        src: "tmp/JSONSimpleTypes.js"
      },
      exampleJSONMaybeNullable: {
        src: "tmp/MaybeNullable.js"
      },
      exampleObjects: {
        src: "tmp/Objects.js"
      },
      exampleParseErrors: {
        src: "tmp/ParseErrors.js"
      }
    }

  });

  grunt.loadNpmTasks("grunt-contrib-clean");
  grunt.loadNpmTasks("grunt-execute");
  grunt.loadNpmTasks("grunt-purescript");
  
  grunt.registerTask("examples", ["psc", "execute"]);
  grunt.registerTask("make", ["pscMake", "dotPsci", "docgen"]);
  grunt.registerTask("default", ["make"]);
};

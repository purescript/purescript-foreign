/* global exports */
"use strict";

// module Data.Foreign.Keys

exports.unsafeKeys = Object.keys || function (value) {
  var keys = [];
  for (var prop in value) {
    if (Object.prototype.hasOwnProperty.call(value, prop)) {
      keys.push(prop);
    }
  }
  return keys;
};

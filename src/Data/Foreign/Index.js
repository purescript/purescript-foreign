"use strict";

exports.unsafeReadPropImpl = function (f, f2, s, key, value) {
  if (value == null) {
    // Fail with "not an object error"
    return f;
  } else {
    // Succeed or fail with "property does not
    // exist or index does not existerror"
    return (key in value) ? s(value[key]) : f2;
  }
};

exports.unsafeHasOwnProperty = function (prop, value) {
  return Object.prototype.hasOwnProperty.call(value, prop);
};

exports.unsafeHasProperty = function (prop, value) {
  return prop in value;
};

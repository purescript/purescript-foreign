# Changelog

Notable changes to this project are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Breaking changes:

New features:

Bugfixes:

Other improvements:

## [v6.0.0](https://github.com/purescript/purescript-foreign/releases/tag/v6.0.0) - 2021-02-26

Breaking changes:
- Added support for PureScript 0.14 and dropped support for all previous versions (#80)

New features:

Bugfixes:

Other improvements:
- Migrated CI to GitHub Actions and updated installation instructions to use Spago (#81)
- Added a CHANGELOG.md file and pull request template (#82, #83)
- Replaced `unsafeToForeign` and `unsafeFromForeign` with `unsafeCoerce` (#72)

## [v5.0.0](https://github.com/purescript/purescript-foreign/releases/tag/v5.0.0) - 2018-05-24

- Updated for PureScript 0.12
- `renderForeignError` now renders nested errors correcty (@abhin4v)
- The namespace is now `Foreign` rather than `Data.Foreign`
- The `JSONError` constructor was removed. This library is not for JSON, it was a bad name - use `ForeignError` instead.
- `toForeign` has been renamed as `unsafeToForeign` with a comment explaining its intended usage and potential risks

## [v4.0.1](https://github.com/purescript/purescript-foreign/releases/tag/v4.0.1) - 2017-06-08

Fix `Show` instance for `ForeignError` (@rightfold)

## [v4.0.0](https://github.com/purescript/purescript-foreign/releases/tag/v4.0.0) - 2017-03-29

- Updated for PureScript 0.11
- The library has been drastically simplified to focus on its core use; validating and extracting data from foreign values. This involves changes such as:
    - Removal of `IsForeign` / `AsForeign` classes
    - Removal of `parseJSON` as this library is not intended for general JSON parsing
- New functions were added for `readNull`, `readUndefined`, `readNullOrUndefined` rather than using the newtypes to direct `IsForeign` choice as it was before
- The `(!)` index/property reading operator has been enhanced to work with `Foreign` or `F Foreign` on the left hand side, allowing for chained property reads

## [v3.2.0](https://github.com/purescript/purescript-foreign/releases/tag/v3.2.0) - 2017-01-29

Add instances for `Null`, `Undefined` and `NullOrUndefined` (@felixSchl)

## [v3.0.1](https://github.com/purescript/purescript-foreign/releases/tag/v3.0.1) - 2016-11-14

- Fixed shadowed name warning

## [v3.0.0](https://github.com/purescript/purescript-foreign/releases/tag/v3.0.0) - 2016-10-16

- Updated lists dependency

## [v2.0.0](https://github.com/purescript/purescript-foreign/releases/tag/v2.0.0) - 2016-10-13

- Updated dependecies
- `F` now uses `Except` and allows for the accumulation of multiple errors when using `<|>` in parsing

## [v1.1.0](https://github.com/purescript/purescript-foreign/releases/tag/v1.1.0) - 2016-08-09

- Added `AsForeign` class and combinators for writing values as `Foreign` (@puffnfresh)

## [v1.0.0](https://github.com/purescript/purescript-foreign/releases/tag/v1.0.0) - 2016-06-01

This release is intended for the PureScript 0.9.1 compiler and newer.

**Note**: The v1.0.0 tag is not meant to indicate the library is “finished”, the core libraries are all being bumped to this for the 0.9 compiler release so as to use semver more correctly.

## [v1.0.0-rc.1](https://github.com/purescript/purescript-foreign/releases/tag/v1.0.0-rc.1) - 2016-03-25

- Release candidate for the psc 0.8+ core libraries

## [v0.7.2](https://github.com/purescript/purescript-foreign/releases/tag/v0.7.2) - 2015-11-20

- Fixed shadowed type variable warnings (@tfausak)

## [v0.7.1](https://github.com/purescript/purescript-foreign/releases/tag/v0.7.1) - 2015-11-09

Fix a type error.

## [v0.7.0](https://github.com/purescript/purescript-foreign/releases/tag/v0.7.0) - 2015-08-13

- Updated dependencies

## [v0.6.0](https://github.com/purescript/purescript-foreign/releases/tag/v0.6.0) - 2015-08-02

- Updated dependencies

## [v0.5.1](https://github.com/purescript/purescript-foreign/releases/tag/v0.5.1) - 2015-07-19

- Added `IsForeign` instances for `Int` and `Char` (@anttih)

## [v0.5.0](https://github.com/purescript/purescript-foreign/releases/tag/v0.5.0) - 2015-06-30

This release works with versions 0.7.\* of the PureScript compiler. It will not work with older versions. If you are using an older version, you should require an older, compatible version of this library.

## [v0.5.0-rc.2](https://github.com/purescript/purescript-foreign/releases/tag/v0.5.0-rc.2) - 2015-06-15

Rename `!` operator to `ix`.

## [v0.5.0-rc.1](https://github.com/purescript/purescript-foreign/releases/tag/v0.5.0-rc.1) - 2015-06-10

Initial release candidate of the library intended for the 0.7 compiler.

## [v0.4.2](https://github.com/purescript/purescript-foreign/releases/tag/v0.4.2) - 2015-03-26

- `unsafeReadTagged` is now exposed (@garyb)

## [v0.4.1](https://github.com/purescript/purescript-foreign/releases/tag/v0.4.1) - 2015-03-20

Updated docs

## [v0.4.0](https://github.com/purescript/purescript-foreign/releases/tag/v0.4.0) - 2015-02-21

**This release requires PureScript v0.6.8 or later**
- Updated dependencies

## [v0.3.0](https://github.com/purescript/purescript-foreign/releases/tag/v0.3.0) - 2015-01-10

- Made dependency versions explicit (@garyb)

## [v0.2.3](https://github.com/purescript/purescript-foreign/releases/tag/v0.2.3) - 2014-12-11

- Added ES3 fallbacks for `Array.isArray` and `Object.keys` (@davidchambers)

## [v0.2.2](https://github.com/purescript/purescript-foreign/releases/tag/v0.2.2) - 2014-11-19



## [v0.2.1](https://github.com/purescript/purescript-foreign/releases/tag/v0.2.1) - 2014-11-18

- `IsForeign` instance for `Foreign`. (@MichaelXavier)

## [v0.2.0](https://github.com/purescript/purescript-foreign/releases/tag/v0.2.0) - 2014-08-20

Quite a few breaking changes to both names and types:
- A type for errors instead of using string concatenation.
- Breaking a few functions out into their own submodules.
- Adding types and instances to handle null-like values.
- Use the `Either` monad instead of the `ForeignParser` monad.

## [v0.1.6](https://github.com/purescript/purescript-foreign/releases/tag/v0.1.6) - 2014-08-09

- Removed unused dependency on `purescript-globals` (@garyb)

## [v0.1.5](https://github.com/purescript/purescript-foreign/releases/tag/v0.1.5) - 2014-08-08

- Removed `ReadForeign Error` instance after `Error` was removed from `Global` (@AitorATuin)

## [v0.1.4](https://github.com/purescript/purescript-foreign/releases/tag/v0.1.4) - 2014-07-29

- Added `index` (@philopon)
- Rewrote some calls to `runFnX` to trigger inlining optimisation (@garyb)

## [v0.1.3](https://github.com/purescript/purescript-foreign/releases/tag/v0.1.3) - 2014-07-26

- Updated FFI code to work for changes in codegen (@garyb)
- Added `keys` to read a list of key names from an object (@andreypopp)
- Fixed bug in `prop` that may have resulted in runtime errors when the object is null (@andreypopp)

## [v0.1.2](https://github.com/purescript/purescript-foreign/releases/tag/v0.1.2) - 2014-06-02

- Added `ReadForeign Error` instance (garyb)

## [v0.1.1](https://github.com/purescript/purescript-foreign/releases/tag/v0.1.1) - 2014-04-27



## [v0.1.0](https://github.com/purescript/purescript-foreign/releases/tag/v0.1.0) - 2014-04-26




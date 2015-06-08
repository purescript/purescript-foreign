## Module Data.Foreign.NullOrUndefined

#### `NullOrUndefined`

``` purescript
newtype NullOrUndefined a
  = NullOrUndefined (Maybe a)
```

A `newtype` wrapper whose `IsForeign` instance correctly handles
null and undefined values.

Conceptually, this type represents values which may be `null`
or `undefined`.

#### `runNullOrUndefined`

``` purescript
runNullOrUndefined :: forall a. NullOrUndefined a -> Maybe a
```

Unwrap a `NullOrUndefined` value

#### `readNullOrUndefined`

``` purescript
readNullOrUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (NullOrUndefined a)
```

Read a `NullOrUndefined` value



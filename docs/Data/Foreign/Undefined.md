## Module Data.Foreign.Undefined

#### `Undefined`

``` purescript
newtype Undefined a
  = Undefined (Maybe a)
```

A `newtype` wrapper whose `IsForeign` instance correctly handles
undefined values.

Conceptually, this type represents values which may be `undefined`,
but not `null`.

#### `runUndefined`

``` purescript
runUndefined :: forall a. Undefined a -> Maybe a
```

Unwrap an `Undefined` value

#### `readUndefined`

``` purescript
readUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (Undefined a)
```

Read an `Undefined` value



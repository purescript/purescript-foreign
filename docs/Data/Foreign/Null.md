## Module Data.Foreign.Null

#### `Null`

``` purescript
newtype Null a
  = Null (Maybe a)
```

A `newtype` wrapper whose `IsForeign` instance correctly handles
null values.

Conceptually, this type represents values which may be `null`,
but not `undefined`.

#### `runNull`

``` purescript
runNull :: forall a. Null a -> Maybe a
```

Unwrap a `Null` value

#### `readNull`

``` purescript
readNull :: forall a. (Foreign -> F a) -> Foreign -> F (Null a)
```

Read a `Null` value



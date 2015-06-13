## Module Data.Foreign.Index

This module defines a type class for types which act like
_property indices_.

#### `Index`

``` purescript
class Index i where
  ix :: Foreign -> i -> F Foreign
  hasProperty :: i -> Foreign -> Boolean
  hasOwnProperty :: i -> Foreign -> Boolean
  errorAt :: i -> ForeignError -> ForeignError
```

This type class identifies types wich act like _property indices_.

The canonical instances are for `String`s and `Number`s.

##### Instances
``` purescript
instance indexString :: Index String
instance indexInt :: Index Int
```

#### `(!)`

``` purescript
(!) :: forall i. (Index i) => Foreign -> i -> F Foreign
```

_left-associative / precedence 9_

An infix alias for `ix`.

#### `prop`

``` purescript
prop :: String -> Foreign -> F Foreign
```

Attempt to read a value from a foreign value property

#### `index`

``` purescript
index :: Int -> Foreign -> F Foreign
```

Attempt to read a value from a foreign value at the specified numeric index



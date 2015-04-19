# Module Documentation

## Module Data.Foreign.Index


This module defines a type class for types which act like
_property indices_.

#### `Index`

``` purescript
class Index i where
  (!) :: Foreign -> i -> F Foreign
  hasProperty :: i -> Foreign -> Boolean
  hasOwnProperty :: i -> Foreign -> Boolean
  errorAt :: i -> ForeignError -> ForeignError
```

This type class identifies types wich act like _property indices_.

The canonical instances are for `String`s and `Number`s.

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

#### `indexString`

``` purescript
instance indexString :: Index String
```


#### `indexNumber`

``` purescript
instance indexNumber :: Index Int
```





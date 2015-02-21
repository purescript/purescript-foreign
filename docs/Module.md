# Module Documentation

## Module Data.Foreign

#### `Foreign`

``` purescript
data Foreign :: *
```


#### `ForeignError`

``` purescript
data ForeignError
  = TypeMismatch String String
  | ErrorAtIndex Number ForeignError
  | ErrorAtProperty String ForeignError
  | JSONError String
```


#### `showForeignError`

``` purescript
instance showForeignError :: Show ForeignError
```


#### `eqForeignError`

``` purescript
instance eqForeignError :: Eq ForeignError
```


#### `F`

``` purescript
type F = Either ForeignError
```


#### `parseJSON`

``` purescript
parseJSON :: String -> F Foreign
```


#### `toForeign`

``` purescript
toForeign :: forall a. a -> Foreign
```


#### `unsafeFromForeign`

``` purescript
unsafeFromForeign :: forall a. Foreign -> a
```


#### `typeOf`

``` purescript
typeOf :: Foreign -> String
```


#### `tagOf`

``` purescript
tagOf :: Foreign -> String
```


#### `isNull`

``` purescript
isNull :: Foreign -> Boolean
```


#### `isUndefined`

``` purescript
isUndefined :: Foreign -> Boolean
```


#### `isArray`

``` purescript
isArray :: Foreign -> Boolean
```


#### `readString`

``` purescript
readString :: Foreign -> F String
```


#### `readBoolean`

``` purescript
readBoolean :: Foreign -> F Boolean
```


#### `readNumber`

``` purescript
readNumber :: Foreign -> F Number
```


#### `readArray`

``` purescript
readArray :: Foreign -> F [Foreign]
```



## Module Data.Foreign.Class

#### `IsForeign`

``` purescript
class IsForeign a where
  read :: Foreign -> F a
```


#### `foreignIsForeign`

``` purescript
instance foreignIsForeign :: IsForeign Foreign
```


#### `stringIsForeign`

``` purescript
instance stringIsForeign :: IsForeign String
```


#### `booleanIsForeign`

``` purescript
instance booleanIsForeign :: IsForeign Boolean
```


#### `numberIsForeign`

``` purescript
instance numberIsForeign :: IsForeign Number
```


#### `arrayIsForeign`

``` purescript
instance arrayIsForeign :: (IsForeign a) => IsForeign [a]
```


#### `nullIsForeign`

``` purescript
instance nullIsForeign :: (IsForeign a) => IsForeign (Null a)
```


#### `undefinedIsForeign`

``` purescript
instance undefinedIsForeign :: (IsForeign a) => IsForeign (Undefined a)
```


#### `nullOrUndefinedIsForeign`

``` purescript
instance nullOrUndefinedIsForeign :: (IsForeign a) => IsForeign (NullOrUndefined a)
```


#### `readJSON`

``` purescript
readJSON :: forall a. (IsForeign a) => String -> F a
```


#### `readWith`

``` purescript
readWith :: forall a e. (IsForeign a) => (ForeignError -> e) -> Foreign -> Either e a
```


#### `readProp`

``` purescript
readProp :: forall a i. (IsForeign a, Index i) => i -> Foreign -> F a
```



## Module Data.Foreign.Index

#### `Index`

``` purescript
class Index i where
  (!) :: Foreign -> i -> F Foreign
  hasProperty :: i -> Foreign -> Boolean
  hasOwnProperty :: i -> Foreign -> Boolean
  errorAt :: i -> ForeignError -> ForeignError
```


#### `prop`

``` purescript
prop :: String -> Foreign -> F Foreign
```


#### `index`

``` purescript
index :: Number -> Foreign -> F Foreign
```


#### `indexString`

``` purescript
instance indexString :: Index String
```


#### `indexNumber`

``` purescript
instance indexNumber :: Index Number
```



## Module Data.Foreign.Keys

#### `keys`

``` purescript
keys :: Foreign -> F [String]
```



## Module Data.Foreign.Null

#### `Null`

``` purescript
newtype Null a
  = Null (Maybe a)
```


#### `runNull`

``` purescript
runNull :: forall a. Null a -> Maybe a
```


#### `readNull`

``` purescript
readNull :: forall a. (Foreign -> F a) -> Foreign -> F (Null a)
```



## Module Data.Foreign.NullOrUndefined

#### `NullOrUndefined`

``` purescript
newtype NullOrUndefined a
  = NullOrUndefined (Maybe a)
```


#### `runNullOrUndefined`

``` purescript
runNullOrUndefined :: forall a. NullOrUndefined a -> Maybe a
```


#### `readNullOrUndefined`

``` purescript
readNullOrUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (NullOrUndefined a)
```



## Module Data.Foreign.Undefined

#### `Undefined`

``` purescript
newtype Undefined a
  = Undefined (Maybe a)
```


#### `runUndefined`

``` purescript
runUndefined :: forall a. Undefined a -> Maybe a
```


#### `readUndefined`

``` purescript
readUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (Undefined a)
```
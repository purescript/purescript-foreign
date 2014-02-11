module Main where

  import Prelude
  import Either
  import JSON 
  
  foreign import toJSON "function toJSON (obj) { return obj; }" :: forall a. a -> JSON
  
  subtree json = do
    x <- prop "x" json >>= num
    y <- prop "y" json >>= num
    return { x: x, y: y }
  
  parse json = do
    foo <- prop "foo" json >>= str
    bar <- prop "bar" json >>= bool
    baz <- prop "baz" json >>= num
    list <- prop "list" json >>= arrOf subtree
    return { foo: foo, bar: bar, baz: baz, list: list }
  
  main = do
    let obj = toJSON { foo: "hello", bar: true, baz: 1, list: [{ x: 1, y: 2 }, { x: 3, y: 4 }] }
    case parse obj of
      Left err -> Trace.print err
      Right result -> Trace.print $ toJSON result
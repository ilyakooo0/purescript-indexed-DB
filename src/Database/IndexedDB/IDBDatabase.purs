module Database.IndexedDB.IDBDatabase
  ( class IDBDatabase, close, createObjectStore, deleteObjectStore, transaction
  , StoreName
  , name
  , objectStoreNames
  , version
  ) where

import Prelude                           (Unit, show)

import Control.Monad.Eff                 (Eff)
import Control.Monad.Eff.Exception       (EXCEPTION)
import Data.Function.Uncurried            as Fn
import Data.Function.Uncurried           (Fn2, Fn3, Fn4)

import Database.IndexedDB.Core
import Database.IndexedDB.IDBObjectStore (IDBObjectStoreParameters)


--------------------
-- INTERFACE
--
class IDBDatabase db where
  close :: forall e. db -> Eff (idb :: IDB, exception :: EXCEPTION | e) Unit
  createObjectStore :: forall e. db -> StoreName -> IDBObjectStoreParameters -> Eff (idb :: IDB, exception :: EXCEPTION | e) ObjectStore
  deleteObjectStore :: forall e.  db -> StoreName -> Eff (idb :: IDB, exception :: EXCEPTION | e) ObjectStore
  transaction :: forall e. db -> KeyPath -> TransactionMode -> Eff (idb :: IDB, exception :: EXCEPTION | e) Transaction


type StoreName = String


--------------------
-- ATTRIBUTES
--
name :: Database -> String
name =
  _name


objectStoreNames :: Database -> Array String
objectStoreNames =
  _objectStoreNames


version :: Database -> Int
version =
  _version


--------------------
-- EVENT HANDLERS
--
-- onAbort :: forall e. Database -> Eff (idb :: IDB, exception :: EXCEPTION | e) Unit -> Eff (idb :: IDB, exception :: EXCEPTION | e) Unit



--------------------
-- INSTANCES
--
instance idbDatabaseDatabase :: IDBDatabase Database where
  close =
    _close

  createObjectStore db name' opts =
    Fn.runFn3 _createObjectStore db name' opts

  deleteObjectStore db name' =
    Fn.runFn2 _deleteObjectStore db name'

  transaction db stores mode' =
    Fn.runFn4 _transaction show db stores mode'


--------------------
-- FFI
--
foreign import _close :: forall db e. db -> Eff (idb :: IDB, exception :: EXCEPTION | e) Unit


foreign import _createObjectStore :: forall db e. Fn3 db String { keyPath :: Array String, autoIncrement :: Boolean } (Eff (idb :: IDB, exception :: EXCEPTION | e) ObjectStore)


foreign import _deleteObjectStore :: forall db e. Fn2 db String (Eff (idb :: IDB, exception :: EXCEPTION | e) ObjectStore)


foreign import _name :: Database -> String


foreign import _objectStoreNames :: Database -> Array String


foreign import _transaction :: forall db e. Fn4 (db -> String) db (Array String) TransactionMode (Eff (idb :: IDB, exception :: EXCEPTION | e) Transaction)


foreign import _version :: Database -> Int

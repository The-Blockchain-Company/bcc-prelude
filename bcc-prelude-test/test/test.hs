module Main
  ( main
  ) where

import Bcc.Prelude
import Test.Bcc.Prelude

import qualified Test.Bcc.Prelude.GHC.Heap.NormalFormSpec
import qualified Test.Bcc.Prelude.GHC.Heap.SizeSpec
import qualified Test.Bcc.Prelude.GHC.Heap.TreeSpec

main :: IO ()
main = runTests
  [ Test.Bcc.Prelude.GHC.Heap.NormalFormSpec.tests
  , Test.Bcc.Prelude.GHC.Heap.SizeSpec.tests
  , Test.Bcc.Prelude.GHC.Heap.TreeSpec.tests
  ]

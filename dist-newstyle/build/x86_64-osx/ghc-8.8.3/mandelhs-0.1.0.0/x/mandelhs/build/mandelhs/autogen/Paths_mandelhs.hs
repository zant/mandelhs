{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_mandelhs (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/gonza/.cabal/bin"
libdir     = "/Users/gonza/.cabal/lib/x86_64-osx-ghc-8.8.3/mandelhs-0.1.0.0-inplace-mandelhs"
dynlibdir  = "/Users/gonza/.cabal/lib/x86_64-osx-ghc-8.8.3"
datadir    = "/Users/gonza/.cabal/share/x86_64-osx-ghc-8.8.3/mandelhs-0.1.0.0"
libexecdir = "/Users/gonza/.cabal/libexec/x86_64-osx-ghc-8.8.3/mandelhs-0.1.0.0"
sysconfdir = "/Users/gonza/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "mandelhs_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "mandelhs_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "mandelhs_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "mandelhs_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "mandelhs_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "mandelhs_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)

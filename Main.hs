{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad
import Data.Complex
import Data.Word
import Foreign.C.Types
import Linear.V2
import SDL
import SDL.Vect
import System.Environment

mapRange n stop1 start2 stop2 = (n / stop1 * (stop2 - start2)) + start2

mapWidth n = mapRange n width (-2) 2

mapHeight n = mapRange n height (-2) 2

width = 600

height = 600

data Pointo = Pointo
  { x :: CInt,
    y :: CInt,
    it :: Word8
  }

getX  Pointo {x=x} = x
getY  Pointo {y=y} = y
getIt  Pointo {it=it} = it

renderor :: Renderer -> Pointo -> IO ()
renderor renderer its = do
  let it = getIt its
  rendererDrawColor renderer $= V4 0 it 200 255
  drawPoint renderer (P (V2 (getX its) (getY its)))

iterations :: Complex Double -> Complex Double -> Word8 -> Pointo
iterations c z it = do
  let c' = mapWidth (realPart c) :+ mapHeight (imagPart c)
  if realPart (abs z) < 2 && it < 255 then iterations c ((z * z) + c') (it + 1) else Pointo {it = it, x = round $ realPart c, y = round $ imagPart c}

renderMandel renderer = do
  let c = concatMap (\x -> map (:+ x) [0 .. height]) [0 .. width]
      its = map (\x -> iterations x (0.0 :+ 0.0) 0) c
  mapM_ (renderor renderer) its

appLoop :: Renderer -> IO ()
appLoop renderer = do
  events <- pollEvents
  let eventIsKeyPress event = case eventPayload event of
        KeyboardEvent keyboardEvent -> keyboardEventKeyMotion keyboardEvent == Pressed
        _ -> False
      keyPressed = any eventIsKeyPress events
  rendererDrawColor renderer $= V4 0 0 255 255
  clear renderer
  renderMandel renderer
  present renderer
  unless keyPressed (appLoop renderer)

main :: IO ()
main = do
  initializeAll
  window <- createWindow "Hi" defaultWindow
  renderer <- createRenderer window (-1) defaultRenderer
  appLoop renderer
  destroyWindow window

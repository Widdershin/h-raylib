{-# LANGUAGE TemplateHaskell #-}

-- | Bindings to @rtext@
module Raylib.Core.Text
  ( -- * High level
    getFontDefault,
    loadFont,
    loadFontEx,
    loadFontFromImage,
    loadFontFromMemory,
    loadFontData,
    genImageFontAtlas,
    unloadFont,
    isFontValid,
    exportFontAsCode,
    drawFPS,
    drawText,
    drawTextEx,
    drawTextPro,
    drawTextCodepoint,
    drawTextCodepoints,
    setTextLineSpacing,
    measureText,
    measureTextEx,
    getGlyphIndex,
    getGlyphInfo,
    getGlyphAtlasRec,
    loadUTF8,
    loadCodepoints,
    getCodepointCount,
    getCodepointNext,
    getCodepointPrevious,
    codepointToUTF8,

    -- * Native
    c'getFontDefault,
    c'loadFont,
    c'loadFontEx,
    c'loadFontFromImage,
    c'loadFontFromMemory,
    c'loadFontData,
    c'genImageFontAtlas,
    c'unloadFontData,
    c'isFontValid,
    c'unloadFont,
    c'exportFontAsCode,
    c'drawFPS,
    c'drawText,
    c'drawTextEx,
    c'drawTextPro,
    c'drawTextCodepoint,
    c'drawTextCodepoints,
    c'setTextLineSpacing,
    c'measureText,
    c'measureTextEx,
    c'getGlyphIndex,
    c'getGlyphInfo,
    c'getGlyphAtlasRec,
    c'loadUTF8,
    c'loadCodepoints,
    c'getCodepointCount,
    c'getCodepointNext,
    c'getCodepointPrevious,
    c'codepointToUTF8,
  )
where

import Foreign (Ptr, Storable (peek, sizeOf), nullPtr, toBool)
import Foreign.C
  ( CBool (..),
    CFloat (..),
    CInt (..),
    CString,
    CUChar,
    peekCString,
    withCString,
  )
import Raylib.Internal (WindowResources, unloadSingleTexture)
import Raylib.Internal.Foreign
  ( pop,
    popCArray,
    popCString,
    withFreeable,
    withFreeableArray,
    withFreeableArray2D,
    withFreeableArrayLen,
  )
import Raylib.Internal.TH (genNative)
import Raylib.Types
  ( Color,
    Font (font'texture),
    FontType,
    GlyphInfo,
    Image,
    Rectangle,
    Texture (texture'id),
    Vector2,
  )

$( genNative
     [ ("c'getFontDefault", "GetFontDefault_", "rl_bindings.h", [t|IO (Ptr Font)|]),
       ("c'loadFont", "LoadFont_", "rl_bindings.h", [t|CString -> IO (Ptr Font)|]),
       ("c'loadFontEx", "LoadFontEx_", "rl_bindings.h", [t|CString -> CInt -> Ptr CInt -> CInt -> IO (Ptr Font)|]),
       ("c'loadFontFromImage", "LoadFontFromImage_", "rl_bindings.h", [t|Ptr Image -> Ptr Color -> CInt -> IO (Ptr Font)|]),
       ("c'loadFontFromMemory", "LoadFontFromMemory_", "rl_bindings.h", [t|CString -> Ptr CUChar -> CInt -> CInt -> Ptr CInt -> CInt -> IO (Ptr Font)|]),
       ("c'loadFontData", "LoadFontData_", "rl_bindings.h", [t|Ptr CUChar -> CInt -> CInt -> Ptr CInt -> CInt -> CInt -> IO (Ptr GlyphInfo)|]),
       ("c'genImageFontAtlas", "GenImageFontAtlas_", "rl_bindings.h", [t|Ptr GlyphInfo -> Ptr (Ptr Rectangle) -> CInt -> CInt -> CInt -> CInt -> IO (Ptr Image)|]),
       ("c'unloadFontData", "UnloadFontData_", "rl_bindings.h", [t|Ptr GlyphInfo -> CInt -> IO ()|]),
       ("c'isFontValid", "IsFontValid_", "rl_bindings.h", [t|Ptr Font -> IO CBool|]),
       ("c'unloadFont", "UnloadFont_", "rl_bindings.h", [t|Ptr Font -> IO ()|]),
       ("c'exportFontAsCode", "ExportFontAsCode_", "rl_bindings.h", [t|Ptr Font -> CString -> IO CBool|]),
       ("c'drawFPS", "DrawFPS_", "rl_bindings.h", [t|CInt -> CInt -> IO ()|]),
       ("c'drawText", "DrawText_", "rl_bindings.h", [t|CString -> CInt -> CInt -> CInt -> Ptr Color -> IO ()|]),
       ("c'drawTextEx", "DrawTextEx_", "rl_bindings.h", [t|Ptr Font -> CString -> Ptr Vector2 -> CFloat -> CFloat -> Ptr Color -> IO ()|]),
       ("c'drawTextPro", "DrawTextPro_", "rl_bindings.h", [t|Ptr Font -> CString -> Ptr Vector2 -> Ptr Vector2 -> CFloat -> CFloat -> CFloat -> Ptr Color -> IO ()|]),
       ("c'drawTextCodepoint", "DrawTextCodepoint_", "rl_bindings.h", [t|Ptr Font -> CInt -> Ptr Vector2 -> CFloat -> Ptr Color -> IO ()|]),
       ("c'drawTextCodepoints", "DrawTextCodepoints_", "rl_bindings.h", [t|Ptr Font -> Ptr CInt -> CInt -> Ptr Vector2 -> CFloat -> CFloat -> Ptr Color -> IO ()|]),
       ("c'setTextLineSpacing", "SetTextLineSpacing_", "rl_bindings.h", [t|CInt -> IO ()|]),
       ("c'measureText", "MeasureText_", "rl_bindings.h", [t|CString -> CInt -> IO CInt|]),
       ("c'measureTextEx", "MeasureTextEx_", "rl_bindings.h", [t|Ptr Font -> CString -> CFloat -> CFloat -> IO (Ptr Vector2)|]),
       ("c'getGlyphIndex", "GetGlyphIndex_", "rl_bindings.h", [t|Ptr Font -> CInt -> IO CInt|]),
       ("c'getGlyphInfo", "GetGlyphInfo_", "rl_bindings.h", [t|Ptr Font -> CInt -> IO (Ptr GlyphInfo)|]),
       ("c'getGlyphAtlasRec", "GetGlyphAtlasRec_", "rl_bindings.h", [t|Ptr Font -> CInt -> IO (Ptr Rectangle)|]),
       ("c'loadUTF8", "LoadUTF8_", "rl_bindings.h", [t|Ptr CInt -> CInt -> IO CString|]),
       ("c'loadCodepoints", "LoadCodepoints_", "rl_bindings.h", [t|CString -> Ptr CInt -> IO (Ptr CInt)|]),
       ("c'getCodepointCount", "GetCodepointCount_", "rl_bindings.h", [t|CString -> IO CInt|]),
       ("c'getCodepointNext", "GetCodepointNext_", "rl_bindings.h", [t|CString -> Ptr CInt -> IO CInt|]),
       ("c'getCodepointPrevious", "GetCodepointPrevious_", "rl_bindings.h", [t|CString -> Ptr CInt -> IO CInt|]),
       ("c'codepointToUTF8", "CodepointToUTF8_", "rl_bindings.h", [t|CInt -> Ptr CInt -> IO CString|])
     ]
 )

getFontDefault :: IO Font
getFontDefault = c'getFontDefault >>= pop

loadFont :: String -> IO Font
loadFont fileName = withCString fileName c'loadFont >>= pop

loadFontEx :: String -> Int -> Maybe [Int] -> IO Font
loadFontEx fileName fontSize codepoints =
  withCString
    fileName
    ( \f -> case codepoints of
        Just codepoints' -> withFreeableArrayLen (map fromIntegral codepoints') (\l c -> c'loadFontEx f (fromIntegral fontSize) c (fromIntegral l))
        Nothing -> c'loadFontEx f (fromIntegral fontSize) nullPtr 0
    )
    >>= pop

loadFontFromImage :: Image -> Color -> Int -> IO Font
loadFontFromImage image key firstChar = withFreeable image (\i -> withFreeable key (\k -> c'loadFontFromImage i k (fromIntegral firstChar))) >>= pop

loadFontFromMemory :: String -> [Integer] -> Int -> Maybe [Int] -> IO Font
loadFontFromMemory fileType fileData fontSize codepoints =
  withCString
    fileType
    ( \t ->
        withFreeableArrayLen
          (map fromIntegral fileData)
          ( \size d ->
              case codepoints of
                Just codepoints' ->
                  withFreeableArrayLen
                    (map fromIntegral codepoints')
                    ( \l c -> c'loadFontFromMemory t d (fromIntegral $ size * sizeOf (0 :: CUChar)) (fromIntegral fontSize) c (fromIntegral l)
                    )
                Nothing -> c'loadFontFromMemory t d (fromIntegral $ size * sizeOf (0 :: CUChar)) (fromIntegral fontSize) nullPtr 0
          )
    )
    >>= pop

loadFontData :: [Integer] -> Int -> Maybe [Int] -> FontType -> IO GlyphInfo
loadFontData fileData fontSize codepoints fontType =
  withFreeableArrayLen
    (map fromIntegral fileData)
    ( \size d ->
        case codepoints of
          Just codepoints' ->
            withFreeableArrayLen (map fromIntegral codepoints') (\l c -> c'loadFontData d (fromIntegral (size * sizeOf (0 :: CUChar))) (fromIntegral fontSize) c (fromIntegral l) (fromIntegral (fromEnum fontType)))
          Nothing -> c'loadFontData d (fromIntegral (size * sizeOf (0 :: CUChar))) (fromIntegral fontSize) nullPtr 0 (fromIntegral (fromEnum fontType))
    )
    >>= pop

genImageFontAtlas :: [GlyphInfo] -> [[Rectangle]] -> Int -> Int -> Int -> Int -> IO Image
genImageFontAtlas chars recs glyphCount fontSize padding packMethod = withFreeableArray chars (\c -> withFreeableArray2D recs (\r -> c'genImageFontAtlas c r (fromIntegral glyphCount) (fromIntegral fontSize) (fromIntegral padding) (fromIntegral packMethod))) >>= pop

-- | Unloads a `managed` font from GPU memory (VRAM)
unloadFont :: Font -> WindowResources -> IO ()
unloadFont font = unloadSingleTexture (texture'id $ font'texture font)

isFontValid :: Font -> IO Bool
isFontValid font = toBool <$> withFreeable font c'isFontValid

exportFontAsCode :: Font -> String -> IO Bool
exportFontAsCode font fileName = toBool <$> withFreeable font (withCString fileName . c'exportFontAsCode)

drawFPS :: Int -> Int -> IO ()
drawFPS x y = c'drawFPS (fromIntegral x) (fromIntegral y)

drawText :: String -> Int -> Int -> Int -> Color -> IO ()
drawText text x y fontSize color = withCString text (\t -> withFreeable color (c'drawText t (fromIntegral x) (fromIntegral y) (fromIntegral fontSize)))

drawTextEx :: Font -> String -> Vector2 -> Float -> Float -> Color -> IO ()
drawTextEx font text position fontSize spacing tint = withFreeable font (\f -> withCString text (\t -> withFreeable position (\p -> withFreeable tint (c'drawTextEx f t p (realToFrac fontSize) (realToFrac spacing)))))

drawTextPro :: Font -> String -> Vector2 -> Vector2 -> Float -> Float -> Float -> Color -> IO ()
drawTextPro font text position origin rotation fontSize spacing tint = withFreeable font (\f -> withCString text (\t -> withFreeable position (\p -> withFreeable origin (\o -> withFreeable tint (c'drawTextPro f t p o (realToFrac rotation) (realToFrac fontSize) (realToFrac spacing))))))

drawTextCodepoint :: Font -> Int -> Vector2 -> Float -> Color -> IO ()
drawTextCodepoint font codepoint position fontSize tint = withFreeable font (\f -> withFreeable position (\p -> withFreeable tint (c'drawTextCodepoint f (fromIntegral codepoint) p (realToFrac fontSize))))

drawTextCodepoints :: Font -> [Int] -> Vector2 -> Float -> Float -> Color -> IO ()
drawTextCodepoints font codepoints position fontSize spacing tint = withFreeable font (\f -> withFreeableArrayLen (map fromIntegral codepoints) (\count cp -> withFreeable position (\p -> withFreeable tint (c'drawTextCodepoints f cp (fromIntegral count) p (realToFrac fontSize) (realToFrac spacing)))))

setTextLineSpacing :: Int -> IO ()
setTextLineSpacing = c'setTextLineSpacing . fromIntegral

measureText :: String -> Int -> IO Int
measureText text fontSize = fromIntegral <$> withCString text (\t -> c'measureText t (fromIntegral fontSize))

measureTextEx :: Font -> String -> Float -> Float -> IO Vector2
measureTextEx font text fontSize spacing = withFreeable font (\f -> withCString text (\t -> c'measureTextEx f t (realToFrac fontSize) (realToFrac spacing))) >>= pop

getGlyphIndex :: Font -> Int -> IO Int
getGlyphIndex font codepoint = fromIntegral <$> withFreeable font (\f -> c'getGlyphIndex f (fromIntegral codepoint))

getGlyphInfo :: Font -> Int -> IO GlyphInfo
getGlyphInfo font codepoint = withFreeable font (\f -> c'getGlyphInfo f (fromIntegral codepoint)) >>= pop

getGlyphAtlasRec :: Font -> Int -> IO Rectangle
getGlyphAtlasRec font codepoint = withFreeable font (\f -> c'getGlyphAtlasRec f (fromIntegral codepoint)) >>= pop

loadUTF8 :: [Integer] -> IO String
loadUTF8 codepoints =
  withFreeableArrayLen
    (map fromIntegral codepoints)
    ( \size c ->
        c'loadUTF8 c (fromIntegral size)
    )
    >>= popCString

loadCodepoints :: String -> IO [Int]
loadCodepoints text =
  withCString
    text
    ( \t ->
        withFreeable
          0
          ( \n -> do
              res <- c'loadCodepoints t n
              num <- peek n
              map fromIntegral <$> popCArray (fromIntegral num) res
          )
    )

getCodepointCount :: String -> IO Int
getCodepointCount text = fromIntegral <$> withCString text c'getCodepointCount

getCodepointNext :: String -> IO (Int, Int)
getCodepointNext text =
  withCString
    text
    ( \t ->
        withFreeable
          0
          ( \n ->
              do
                res <- c'getCodepointNext t n
                num <- peek n
                return (fromIntegral res, fromIntegral num)
          )
    )

getCodepointPrevious :: String -> IO (Int, Int)
getCodepointPrevious text =
  withCString
    text
    ( \t ->
        withFreeable
          0
          ( \n ->
              do
                res <- c'getCodepointPrevious t n
                num <- peek n
                return (fromIntegral res, fromIntegral num)
          )
    )

codepointToUTF8 :: Int -> IO String
codepointToUTF8 codepoint = withFreeable 0 (c'codepointToUTF8 $ fromIntegral codepoint) >>= peekCString

{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE TemplateHaskell #-}

-- | Bindings to @raudio@
module Raylib.Core.Audio
  ( -- * High level
    initAudioDevice,
    closeAudioDevice,
    isAudioDeviceReady,
    setMasterVolume,
    getMasterVolume,
    loadWave,
    loadWaveFromMemory,
    loadSound,
    loadSoundFromWave,
    loadSoundAlias,
    unloadSoundAlias,
    updateSound,
    unloadSound,
    isWaveValid,
    isSoundValid,
    exportWave,
    exportWaveAsCode,
    playSound,
    stopSound,
    pauseSound,
    resumeSound,
    isSoundPlaying,
    setSoundVolume,
    setSoundPitch,
    setSoundPan,
    waveCopy,
    waveCrop,
    waveFormat,
    loadWaveSamples,
    loadMusicStream,
    loadMusicStreamFromMemory,
    unloadMusicStream,
    isMusicValid,
    playMusicStream,
    isMusicStreamPlaying,
    updateMusicStream,
    stopMusicStream,
    pauseMusicStream,
    resumeMusicStream,
    seekMusicStream,
    setMusicVolume,
    setMusicPitch,
    setMusicPan,
    getMusicTimeLength,
    getMusicTimePlayed,
    loadAudioStream,
    unloadAudioStream,
    isAudioStreamValid,
    updateAudioStream,
    isAudioStreamProcessed,
    playAudioStream,
    pauseAudioStream,
    resumeAudioStream,
    isAudioStreamPlaying,
    stopAudioStream,
    setAudioStreamVolume,
    setAudioStreamPitch,
    setAudioStreamPan,
    setAudioStreamBufferSizeDefault,
    setAudioStreamCallback,
    attachAudioStreamProcessor,
    detachAudioStreamProcessor,
    attachAudioMixedProcessor,
    detachAudioMixedProcessor,

    -- * Native
    c'initAudioDevice,
    c'closeAudioDevice,
    c'isAudioDeviceReady,
    c'setMasterVolume,
    c'getMasterVolume,
    c'loadWave,
    c'loadWaveFromMemory,
    c'loadSound,
    c'loadSoundFromWave,
    c'loadSoundAlias,
    c'updateSound,
    c'isWaveValid,
    c'unloadWave,
    c'isSoundValid,
    c'unloadSound,
    c'unloadSoundAlias,
    c'exportWave,
    c'exportWaveAsCode,
    c'playSound,
    c'stopSound,
    c'pauseSound,
    c'resumeSound,
    c'isSoundPlaying,
    c'setSoundVolume,
    c'setSoundPitch,
    c'setSoundPan,
    c'waveCopy,
    c'waveCrop,
    c'waveFormat,
    c'loadWaveSamples,
    c'unloadWaveSamples,
    c'loadMusicStream,
    c'loadMusicStreamFromMemory,
    c'isMusicValid,
    c'unloadMusicStream,
    c'playMusicStream,
    c'isMusicStreamPlaying,
    c'updateMusicStream,
    c'stopMusicStream,
    c'pauseMusicStream,
    c'resumeMusicStream,
    c'seekMusicStream,
    c'setMusicVolume,
    c'setMusicPitch,
    c'setMusicPan,
    c'getMusicTimeLength,
    c'getMusicTimePlayed,
    c'loadAudioStream,
    c'isAudioStreamValid,
    c'unloadAudioStream,
    c'updateAudioStream,
    c'isAudioStreamProcessed,
    c'playAudioStream,
    c'pauseAudioStream,
    c'resumeAudioStream,
    c'isAudioStreamPlaying,
    c'stopAudioStream,
    c'setAudioStreamVolume,
    c'setAudioStreamPitch,
    c'setAudioStreamPan,
    c'setAudioStreamBufferSizeDefault,
    c'setAudioStreamCallback,
    c'attachAudioStreamProcessor,
    c'detachAudioStreamProcessor,
    c'attachAudioMixedProcessor,
    c'detachAudioMixedProcessor,

    -- * Callbacks
    mk'audioCallback,
    createAudioCallback,
  )
where

import Foreign (Ptr, Storable (peek, sizeOf), castPtr, toBool, castFunPtr)
import Foreign.C
  ( CBool (..),
    CFloat (..),
    CInt (..),
    CString,
    CUChar (..),
    CUInt (..),
    withCString,
  )
import Raylib.Internal (WindowResources, unloadSingleAudioBuffer, unloadSingleAudioBufferAlias, unloadSingleCtxDataPtr, addFunPtr, unloadSingleFunPtr, releaseAudioWindowResources)
import Raylib.Internal.Foreign
  ( pop,
    popCArray,
    withFreeable,
    withFreeableArrayLen,
  )
import Raylib.Internal.TH (genNative)
import Raylib.Types
  ( AudioCallback,
    AudioStream (audioStream'buffer),
    C'AudioCallback,
    Music (music'ctxData, music'ctxType),
    Sound (sound'stream),
    Wave (wave'channels, wave'frameCount),
  )

$( genNative
     [ ("c'initAudioDevice", "InitAudioDevice_", "rl_bindings.h", [t|IO ()|]),
       ("c'closeAudioDevice", "CloseAudioDevice_", "rl_bindings.h", [t|IO ()|]),
       ("c'isAudioDeviceReady", "IsAudioDeviceReady_", "rl_bindings.h", [t|IO CBool|]),
       ("c'setMasterVolume", "SetMasterVolume_", "rl_bindings.h", [t|CFloat -> IO ()|]),
       ("c'getMasterVolume", "GetMasterVolume_", "rl_bindings.h", [t|IO CFloat|]),
       ("c'loadWave", "LoadWave_", "rl_bindings.h", [t|CString -> IO (Ptr Wave)|]),
       ("c'loadWaveFromMemory", "LoadWaveFromMemory_", "rl_bindings.h", [t|CString -> Ptr CUChar -> CInt -> IO (Ptr Wave)|]),
       ("c'loadSound", "LoadSound_", "rl_bindings.h", [t|CString -> IO (Ptr Sound)|]),
       ("c'loadSoundFromWave", "LoadSoundFromWave_", "rl_bindings.h", [t|Ptr Wave -> IO (Ptr Sound)|]),
       ("c'loadSoundAlias", "LoadSoundAlias_", "rl_bindings.h", [t|Ptr Sound -> IO (Ptr Sound)|]),
       ("c'updateSound", "UpdateSound_", "rl_bindings.h", [t|Ptr Sound -> Ptr () -> CInt -> IO ()|]),
       ("c'isWaveValid", "IsWaveValid_", "rl_bindings.h", [t|Ptr Wave -> IO CBool|]),
       ("c'unloadWave", "UnloadWave_", "rl_bindings.h", [t|Ptr Wave -> IO ()|]),
       ("c'isSoundValid", "IsSoundValid_", "rl_bindings.h", [t|Ptr Sound -> IO CBool|]),
       ("c'unloadSound", "UnloadSound_", "rl_bindings.h", [t|Ptr Sound -> IO ()|]),
       ("c'unloadSoundAlias", "UnloadSoundAlias_", "rl_bindings.h", [t|Ptr Sound -> IO ()|]),
       ("c'exportWave", "ExportWave_", "rl_bindings.h", [t|Ptr Wave -> CString -> IO CBool|]),
       ("c'exportWaveAsCode", "ExportWaveAsCode_", "rl_bindings.h", [t|Ptr Wave -> CString -> IO CBool|]),
       ("c'playSound", "PlaySound_", "rl_bindings.h", [t|Ptr Sound -> IO ()|]),
       ("c'stopSound", "StopSound_", "rl_bindings.h", [t|Ptr Sound -> IO ()|]),
       ("c'pauseSound", "PauseSound_", "rl_bindings.h", [t|Ptr Sound -> IO ()|]),
       ("c'resumeSound", "ResumeSound_", "rl_bindings.h", [t|Ptr Sound -> IO ()|]),
       ("c'isSoundPlaying", "IsSoundPlaying_", "rl_bindings.h", [t|Ptr Sound -> IO CBool|]),
       ("c'setSoundVolume", "SetSoundVolume_", "rl_bindings.h", [t|Ptr Sound -> CFloat -> IO ()|]),
       ("c'setSoundPitch", "SetSoundPitch_", "rl_bindings.h", [t|Ptr Sound -> CFloat -> IO ()|]),
       ("c'setSoundPan", "SetSoundPan_", "rl_bindings.h", [t|Ptr Sound -> CFloat -> IO ()|]),
       ("c'waveCopy", "WaveCopy_", "rl_bindings.h", [t|Ptr Wave -> IO (Ptr Wave)|]),
       ("c'waveCrop", "WaveCrop_", "rl_bindings.h", [t|Ptr Wave -> CInt -> CInt -> IO ()|]),
       ("c'waveFormat", "WaveFormat_", "rl_bindings.h", [t|Ptr Wave -> CInt -> CInt -> CInt -> IO ()|]),
       ("c'loadWaveSamples", "LoadWaveSamples_", "rl_bindings.h", [t|Ptr Wave -> IO (Ptr CFloat)|]),
       ("c'unloadWaveSamples", "UnloadWaveSamples_", "rl_bindings.h", [t|Ptr CFloat -> IO ()|]),
       ("c'loadMusicStream", "LoadMusicStream_", "rl_bindings.h", [t|CString -> IO (Ptr Music)|]),
       ("c'loadMusicStreamFromMemory", "LoadMusicStreamFromMemory_", "rl_bindings.h", [t|CString -> Ptr CUChar -> CInt -> IO (Ptr Music)|]),
       ("c'isMusicValid", "IsMusicValid_", "rl_bindings.h", [t|Ptr Music -> IO CBool|]),
       ("c'unloadMusicStream", "UnloadMusicStream_", "rl_bindings.h", [t|Ptr Music -> IO ()|]),
       ("c'playMusicStream", "PlayMusicStream_", "rl_bindings.h", [t|Ptr Music -> IO ()|]),
       ("c'isMusicStreamPlaying", "IsMusicStreamPlaying_", "rl_bindings.h", [t|Ptr Music -> IO CBool|]),
       ("c'updateMusicStream", "UpdateMusicStream_", "rl_bindings.h", [t|Ptr Music -> IO ()|]),
       ("c'stopMusicStream", "StopMusicStream_", "rl_bindings.h", [t|Ptr Music -> IO ()|]),
       ("c'pauseMusicStream", "PauseMusicStream_", "rl_bindings.h", [t|Ptr Music -> IO ()|]),
       ("c'resumeMusicStream", "ResumeMusicStream_", "rl_bindings.h", [t|Ptr Music -> IO ()|]),
       ("c'seekMusicStream", "SeekMusicStream_", "rl_bindings.h", [t|Ptr Music -> CFloat -> IO ()|]),
       ("c'setMusicVolume", "SetMusicVolume_", "rl_bindings.h", [t|Ptr Music -> CFloat -> IO ()|]),
       ("c'setMusicPitch", "SetMusicPitch_", "rl_bindings.h", [t|Ptr Music -> CFloat -> IO ()|]),
       ("c'setMusicPan", "SetMusicPan_", "rl_bindings.h", [t|Ptr Music -> CFloat -> IO ()|]),
       ("c'getMusicTimeLength", "GetMusicTimeLength_", "rl_bindings.h", [t|Ptr Music -> IO CFloat|]),
       ("c'getMusicTimePlayed", "GetMusicTimePlayed_", "rl_bindings.h", [t|Ptr Music -> IO CFloat|]),
       ("c'loadAudioStream", "LoadAudioStream_", "rl_bindings.h", [t|CUInt -> CUInt -> CUInt -> IO (Ptr AudioStream)|]),
       ("c'isAudioStreamValid", "IsAudioStreamValid_", "rl_bindings.h", [t|Ptr AudioStream -> IO CBool|]),
       ("c'unloadAudioStream", "UnloadAudioStream_", "rl_bindings.h", [t|Ptr AudioStream -> IO ()|]),
       ("c'updateAudioStream", "UpdateAudioStream_", "rl_bindings.h", [t|Ptr AudioStream -> Ptr () -> CInt -> IO ()|]),
       ("c'isAudioStreamProcessed", "IsAudioStreamProcessed_", "rl_bindings.h", [t|Ptr AudioStream -> IO CBool|]),
       ("c'playAudioStream", "PlayAudioStream_", "rl_bindings.h", [t|Ptr AudioStream -> IO ()|]),
       ("c'pauseAudioStream", "PauseAudioStream_", "rl_bindings.h", [t|Ptr AudioStream -> IO ()|]),
       ("c'resumeAudioStream", "ResumeAudioStream_", "rl_bindings.h", [t|Ptr AudioStream -> IO ()|]),
       ("c'isAudioStreamPlaying", "IsAudioStreamPlaying_", "rl_bindings.h", [t|Ptr AudioStream -> IO CBool|]),
       ("c'stopAudioStream", "StopAudioStream_", "rl_bindings.h", [t|Ptr AudioStream -> IO ()|]),
       ("c'setAudioStreamVolume", "SetAudioStreamVolume_", "rl_bindings.h", [t|Ptr AudioStream -> CFloat -> IO ()|]),
       ("c'setAudioStreamPitch", "SetAudioStreamPitch_", "rl_bindings.h", [t|Ptr AudioStream -> CFloat -> IO ()|]),
       ("c'setAudioStreamPan", "SetAudioStreamPan_", "rl_bindings.h", [t|Ptr AudioStream -> CFloat -> IO ()|]),
       ("c'setAudioStreamBufferSizeDefault", "SetAudioStreamBufferSizeDefault_", "rl_bindings.h", [t|CInt -> IO ()|]),
       ("c'setAudioStreamCallback", "SetAudioStreamCallback_", "rl_bindings.h", [t|Ptr AudioStream -> C'AudioCallback -> IO ()|]),
       ("c'attachAudioStreamProcessor", "AttachAudioStreamProcessor_", "rl_bindings.h", [t|Ptr AudioStream -> C'AudioCallback -> IO ()|]),
       ("c'detachAudioStreamProcessor", "DetachAudioStreamProcessor_", "rl_bindings.h", [t|Ptr AudioStream -> C'AudioCallback -> IO ()|]),
       ("c'attachAudioMixedProcessor", "AttachAudioMixedProcessor_", "rl_bindings.h", [t|C'AudioCallback -> IO ()|]),
       ("c'detachAudioMixedProcessor", "DetachAudioMixedProcessor_", "rl_bindings.h", [t|C'AudioCallback -> IO ()|])
     ]
 )

initAudioDevice :: IO ()
initAudioDevice = c'initAudioDevice

closeAudioDevice :: Maybe WindowResources -> IO ()
closeAudioDevice wr = do
  mapM_ releaseAudioWindowResources wr
  c'closeAudioDevice

isAudioDeviceReady :: IO Bool
isAudioDeviceReady = toBool <$> c'isAudioDeviceReady

setMasterVolume :: Float -> IO ()
setMasterVolume volume = c'setMasterVolume (realToFrac volume)

getMasterVolume :: IO Float
getMasterVolume = realToFrac <$> c'getMasterVolume

loadWave :: String -> IO Wave
loadWave fileName = withCString fileName c'loadWave >>= pop

loadWaveFromMemory :: String -> [Integer] -> IO Wave
loadWaveFromMemory fileType fileData = withCString fileType (\f -> withFreeableArrayLen (map fromIntegral fileData) (\size d -> c'loadWaveFromMemory f d (fromIntegral $ size * sizeOf (0 :: CUChar)))) >>= pop

loadSound :: String -> IO Sound
loadSound fileName = withCString fileName c'loadSound >>= pop

loadSoundFromWave :: Wave -> IO Sound
loadSoundFromWave wave = withFreeable wave c'loadSoundFromWave >>= pop

loadSoundAlias :: Sound -> IO Sound
loadSoundAlias source = withFreeable source c'loadSoundAlias >>= pop

-- | Unloads a `managed` sound alias from RAM
unloadSoundAlias :: Sound -> WindowResources -> IO ()
unloadSoundAlias sound = unloadSingleAudioBufferAlias (castPtr (audioStream'buffer (sound'stream sound)))

updateSound :: Sound -> Ptr () -> Int -> IO ()
updateSound sound dataValue sampleCount = withFreeable sound (\s -> c'updateSound s dataValue (fromIntegral sampleCount))

-- | Unloads a `managed` sound from RAM
unloadSound :: Sound -> WindowResources -> IO ()
unloadSound sound = unloadAudioStream (sound'stream sound)

isWaveValid :: Wave -> IO Bool
isWaveValid wave = toBool <$> withFreeable wave c'isWaveValid

isSoundValid :: Sound -> IO Bool
isSoundValid sound = toBool <$> withFreeable sound c'isSoundValid

exportWave :: Wave -> String -> IO Bool
exportWave wave fileName = toBool <$> withFreeable wave (withCString fileName . c'exportWave)

exportWaveAsCode :: Wave -> String -> IO Bool
exportWaveAsCode wave fileName = toBool <$> withFreeable wave (withCString fileName . c'exportWaveAsCode)

playSound :: Sound -> IO ()
playSound sound = withFreeable sound c'playSound

stopSound :: Sound -> IO ()
stopSound sound = withFreeable sound c'stopSound

pauseSound :: Sound -> IO ()
pauseSound sound = withFreeable sound c'pauseSound

resumeSound :: Sound -> IO ()
resumeSound sound = withFreeable sound c'resumeSound

isSoundPlaying :: Sound -> IO Bool
isSoundPlaying sound = toBool <$> withFreeable sound c'isSoundPlaying

setSoundVolume :: Sound -> Float -> IO ()
setSoundVolume sound volume = withFreeable sound (\s -> c'setSoundVolume s (realToFrac volume))

setSoundPitch :: Sound -> Float -> IO ()
setSoundPitch sound pitch = withFreeable sound (\s -> c'setSoundPitch s (realToFrac pitch))

setSoundPan :: Sound -> Float -> IO ()
setSoundPan sound pan = withFreeable sound (\s -> c'setSoundPan s (realToFrac pan))

waveCopy :: Wave -> IO Wave
waveCopy wave = withFreeable wave c'waveCopy >>= pop

waveCrop :: Wave -> Int -> Int -> IO Wave
waveCrop wave initFrame finalFrame = do
  new <- waveCopy wave
  withFreeable new (\w -> c'waveCrop w (fromIntegral initFrame) (fromIntegral finalFrame) >> peek w)

waveFormat :: Wave -> Int -> Int -> Int -> IO ()
waveFormat wave sampleRate sampleSize channels = do
  new <- waveCopy wave
  withFreeable new (\n -> c'waveFormat n (fromIntegral sampleRate) (fromIntegral sampleSize) (fromIntegral channels))

loadWaveSamples :: Wave -> IO [Float]
loadWaveSamples wave =
  withFreeable
    wave
    (\w -> map realToFrac <$> (popCArray (fromIntegral $ wave'frameCount wave * wave'channels wave) =<< c'loadWaveSamples w))

loadMusicStream :: String -> IO Music
loadMusicStream fileName = withCString fileName c'loadMusicStream >>= pop

loadMusicStreamFromMemory :: String -> [Integer] -> IO Music
loadMusicStreamFromMemory fileType streamData =
  withCString fileType (\t -> withFreeableArrayLen (map fromIntegral streamData) (\size d -> c'loadMusicStreamFromMemory t d (fromIntegral $ size * sizeOf (0 :: CUChar)))) >>= pop

-- | Unloads a `managed` music stream from RAM
unloadMusicStream :: Music -> WindowResources -> IO ()
unloadMusicStream music = unloadSingleCtxDataPtr (fromEnum (music'ctxType music)) (music'ctxData music)

isMusicValid :: Music -> IO Bool
isMusicValid music = toBool <$> withFreeable music c'isMusicValid

playMusicStream :: Music -> IO ()
playMusicStream music = withFreeable music c'playMusicStream

isMusicStreamPlaying :: Music -> IO Bool
isMusicStreamPlaying music = toBool <$> withFreeable music c'isMusicStreamPlaying

updateMusicStream :: Music -> IO ()
updateMusicStream music = withFreeable music c'updateMusicStream

stopMusicStream :: Music -> IO ()
stopMusicStream music = withFreeable music c'stopMusicStream

pauseMusicStream :: Music -> IO ()
pauseMusicStream music = withFreeable music c'pauseMusicStream

resumeMusicStream :: Music -> IO ()
resumeMusicStream music = withFreeable music c'resumeMusicStream

seekMusicStream :: Music -> Float -> IO ()
seekMusicStream music position = withFreeable music (\m -> c'seekMusicStream m (realToFrac position))

setMusicVolume :: Music -> Float -> IO ()
setMusicVolume music volume = withFreeable music (\m -> c'setMusicVolume m (realToFrac volume))

setMusicPitch :: Music -> Float -> IO ()
setMusicPitch music pitch = withFreeable music (\m -> c'setMusicPitch m (realToFrac pitch))

setMusicPan :: Music -> Float -> IO ()
setMusicPan music pan = withFreeable music (\m -> c'setMusicPan m (realToFrac pan))

getMusicTimeLength :: Music -> IO Float
getMusicTimeLength music = realToFrac <$> withFreeable music c'getMusicTimeLength

getMusicTimePlayed :: Music -> IO Float
getMusicTimePlayed music = realToFrac <$> withFreeable music c'getMusicTimePlayed

loadAudioStream :: Integer -> Integer -> Integer -> IO AudioStream
loadAudioStream sampleRate sampleSize channels = c'loadAudioStream (fromIntegral sampleRate) (fromIntegral sampleSize) (fromIntegral channels) >>= pop

-- | Unloads a `managed` audio stream from RAM
unloadAudioStream :: AudioStream -> WindowResources -> IO ()
unloadAudioStream stream = unloadSingleAudioBuffer (castPtr $ audioStream'buffer stream)

isAudioStreamValid :: AudioStream -> IO Bool
isAudioStreamValid stream = toBool <$> withFreeable stream c'isAudioStreamValid

updateAudioStream :: AudioStream -> Ptr () -> Int -> IO ()
updateAudioStream stream value frameCount = withFreeable stream (\s -> c'updateAudioStream s value (fromIntegral frameCount))

isAudioStreamProcessed :: AudioStream -> IO Bool
isAudioStreamProcessed stream = toBool <$> withFreeable stream c'isAudioStreamProcessed

playAudioStream :: AudioStream -> IO ()
playAudioStream stream = withFreeable stream c'playAudioStream

pauseAudioStream :: AudioStream -> IO ()
pauseAudioStream stream = withFreeable stream c'pauseAudioStream

resumeAudioStream :: AudioStream -> IO ()
resumeAudioStream stream = withFreeable stream c'resumeAudioStream

isAudioStreamPlaying :: AudioStream -> IO Bool
isAudioStreamPlaying stream = toBool <$> withFreeable stream c'isAudioStreamPlaying

stopAudioStream :: AudioStream -> IO ()
stopAudioStream stream = withFreeable stream c'stopAudioStream

setAudioStreamVolume :: AudioStream -> Float -> IO ()
setAudioStreamVolume stream volume = withFreeable stream (\s -> c'setAudioStreamVolume s (realToFrac volume))

setAudioStreamPitch :: AudioStream -> Float -> IO ()
setAudioStreamPitch stream pitch = withFreeable stream (\s -> c'setAudioStreamPitch s (realToFrac pitch))

setAudioStreamPan :: AudioStream -> Float -> IO ()
setAudioStreamPan stream pan = withFreeable stream (\s -> c'setAudioStreamPan s (realToFrac pan))

setAudioStreamBufferSizeDefault :: Int -> IO ()
setAudioStreamBufferSizeDefault = c'setAudioStreamBufferSizeDefault . fromIntegral

setAudioStreamCallback :: AudioStream -> AudioCallback -> WindowResources -> IO C'AudioCallback
setAudioStreamCallback stream callback window =
  withFreeable
    stream
    ( \s ->
        do
          c <- createAudioCallback callback
          addFunPtr (castFunPtr c) window
          c'setAudioStreamCallback s c
          return c
    )

attachAudioStreamProcessor :: AudioStream -> AudioCallback -> WindowResources -> IO C'AudioCallback
attachAudioStreamProcessor stream callback window =
  withFreeable
    stream
    ( \s ->
        do
          c <- createAudioCallback callback
          addFunPtr (castFunPtr c) window
          c'attachAudioStreamProcessor s c
          return c
    )

detachAudioStreamProcessor :: AudioStream -> C'AudioCallback -> WindowResources -> IO ()
detachAudioStreamProcessor stream callback window =
  withFreeable stream (`c'detachAudioStreamProcessor` callback) >> unloadSingleFunPtr (castFunPtr callback) window

attachAudioMixedProcessor :: AudioCallback -> WindowResources -> IO C'AudioCallback
attachAudioMixedProcessor callback window =
  do
    c <- createAudioCallback callback
    addFunPtr (castFunPtr c) window
    c'attachAudioMixedProcessor c
    return c

detachAudioMixedProcessor :: C'AudioCallback -> WindowResources -> IO ()
detachAudioMixedProcessor callback window = c'detachAudioMixedProcessor callback >> unloadSingleFunPtr (castFunPtr callback) window

foreign import ccall unsafe "wrapper"
  mk'audioCallback ::
    (Ptr () -> CUInt -> IO ()) -> IO C'AudioCallback

-- foreign import ccall unsafe "dynamic"
--   mK'audioCallback ::
--     C'AudioCallback -> (Ptr () -> CUInt -> IO ())

createAudioCallback :: AudioCallback -> IO C'AudioCallback
createAudioCallback callback =
  mk'audioCallback
    (\bufferData frames -> callback bufferData (fromIntegral frames))

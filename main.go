package main

import (
	"log"
	"runtime"
	"time"

	"github.com/Zyko0/go-sdl3/bin/binsdl"
	"github.com/Zyko0/go-sdl3/sdl"
	"github.com/nnnewb/zenscripter/internal/engine"
	"github.com/rotisserie/eris"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

func ProvideLogger() (*zap.Logger, error) {
	encoderConfig := zapcore.EncoderConfig{
		MessageKey:     "message",
		LevelKey:       "level",
		TimeKey:        "time",
		NameKey:        "name",
		CallerKey:      "caller",
		FunctionKey:    "function",
		StacktraceKey:  "stacktrace",
		EncodeLevel:    zapcore.CapitalColorLevelEncoder,
		EncodeTime:     zapcore.RFC3339NanoTimeEncoder,
		EncodeDuration: zapcore.MillisDurationEncoder,
		EncodeCaller:   zapcore.ShortCallerEncoder,
		EncodeName:     zapcore.FullNameEncoder,
	}

	cfg := zap.NewDevelopmentConfig()
	cfg.Level.SetLevel(zapcore.DebugLevel)
	cfg.EncoderConfig = encoderConfig
	return cfg.Build(zap.AddStacktrace(zapcore.ErrorLevel))
}

func ProvideEngine() (*engine.Engine, error) {
	return engine.NewEngine()
}

func mainloop(logger *zap.Logger, en *engine.Engine) error {
	// 确保运行在 main thread
	runtime.LockOSThread()

	lastTick := time.Now()
	sdl.RunLoop(func() error {
		delta := time.Since(lastTick)
		defer func() {
			lastTick = time.Now()
		}()

		if err := en.Update(delta); err != nil {
			return eris.Wrap(err, "engine update failed")
		}

		var ev sdl.Event
		for sdl.PollEvent(&ev) {
			switch ev.Type {
			case sdl.EVENT_QUIT:
				logger.Debug("quit")
				return sdl.EndLoop
			case sdl.EVENT_KEY_DOWN:
				logger.Debug("key pressed", zap.Uint32("key", uint32(ev.KeyboardEvent().Key)))
			default:
				logger.Debug("ignore event", zap.Uint32("event_type", uint32(ev.Type)))
			}
		}

		return nil
	})
	return nil
}

type Library interface {
	Unload()
}

func main() {
	defer binsdl.Load().Unload()
	logger, err := ProvideLogger()
	if err != nil {
		log.Panic(err)
	}

	if err := sdl.Init(sdl.INIT_VIDEO); err != nil {
		logger.Panic("SDL initialization failed", zap.Error(err))
	}
	defer sdl.Quit()

	en, err := ProvideEngine()
	if err != nil {
		logger.Panic("engine initialization failed", zap.Error(err))
	}
	defer en.Shutdown()

	err = mainloop(logger, en)
	if err != nil {
		logger.Panic("mainloop quit with an error", zap.Error(err))
	}
}

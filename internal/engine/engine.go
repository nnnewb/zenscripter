package engine

import (
	"time"

	"github.com/Zyko0/go-sdl3/sdl"
	"github.com/rotisserie/eris"
)

type Engine struct {
	window   *sdl.Window
	renderer *sdl.Renderer
}

func (e *Engine) Shutdown() error {
	e.renderer.Destroy()
	e.window.Destroy()
	return nil
}

func (e *Engine) Update(dt time.Duration) error {
	if err := e.renderer.SetDrawColor(0, 0, 0, 0); err != nil {
		return eris.Wrap(err, "set draw color failed")
	}

	if err := e.renderer.DebugText(50, 50, "Hello world"); err != nil {
		return err
	}

	if err := e.renderer.Present(); err != nil {
		return err
	}

	return nil
}

func NewEngine() (*Engine, error) {
	window, renderer, err := sdl.CreateWindowAndRenderer("zenscripter", 800, 600, sdl.WINDOW_RESIZABLE)
	if err != nil {
		return nil, eris.Wrap(err, "create window and renderer failed")
	}

	return &Engine{
		window:   window,
		renderer: renderer,
	}, nil
}

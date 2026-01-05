package engine

import "github.com/Zyko0/go-sdl3/sdl"

type Node interface {
	GetPosition() Vec2
	SetPosition(Vec2)

	GetRotate() float64
	SetRotate(float64)

	Rotate(float64) float64
	Move(Vec2) Vec2
}

type Sprite interface {
	Render(*sdl.Renderer) error
}

package engine

import (
	"fmt"
	"math"

	"github.com/Zyko0/go-sdl3/sdl"
)

type Vec2 struct {
	x, y float64
}

func (v Vec2) String() string {
	return fmt.Sprintf("Vec2(%f, %f)", v.x, v.y)
}

// ToPoint 方法将 Vec2 类型的向量转换为 sdl.Point 类型
// 该方法会确保 x 和 y 坐标在 int32 类型的取值范围内
func (v Vec2) ToPoint() sdl.Point {
	// 对 x 坐标进行处理，确保其不小于 int32 类型的最小值
	x := math.Max(v.x, math.MinInt32)
	// 对 x 坐标进行处理，确保其不大于 int32 类型的最大值
	x = math.Min(x, math.MaxInt32)

	// 对 y 坐标进行处理，确保其不小于 int32 类型的最小值
	y := math.Max(v.y, math.MinInt32)
	// 对 y 坐标进行处理，确保其不大于 int32 类型的最大值
	y = math.Min(y, math.MaxInt32)

	// 返回处理后的 sdl.Point 结构体
	return sdl.Point{
		X: int32(x),
		Y: int32(y),
	}
}

// Add 返回两个向量的和
func (v Vec2) Add(other Vec2) Vec2 {
	return Vec2{v.x + other.x, v.y + other.y}
}

// Sub 返回两个向量的差
func (v Vec2) Sub(other Vec2) Vec2 {
	return Vec2{v.x - other.x, v.y - other.y}
}

// Mul 返回向量与标量的乘积
func (v Vec2) Mul(scalar float64) Vec2 {
	return Vec2{v.x * scalar, v.y * scalar}
}

// Div 返回向量与标量的商
func (v Vec2) Div(scalar float64) Vec2 {
	return Vec2{v.x / scalar, v.y / scalar}
}

// Dot 返回两个向量的点积
func (v Vec2) Dot(other Vec2) float64 {
	return v.x*other.x + v.y*other.y
}

// Cross 返回两个向量的叉积（在2D中，返回一个标量）
func (v Vec2) Cross(other Vec2) float64 {
	return v.x*other.y - v.y*other.x
}

// Length 返回向量的长度
func (v Vec2) Length() float64 {
	return math.Sqrt(v.x*v.x + v.y*v.y)
}

// LengthSquared 返回向量长度的平方（避免开方运算，提高性能）
func (v Vec2) LengthSquared() float64 {
	return v.x*v.x + v.y*v.y
}

// Normalize 返回归一化后的向量（单位向量）
func (v Vec2) Normalize() Vec2 {
	length := v.Length()
	if length == 0 {
		return Vec2{0, 0}
	}
	return v.Div(length)
}

// Distance 返回两个向量之间的距离
func (v Vec2) Distance(other Vec2) float64 {
	dx := v.x - other.x
	dy := v.y - other.y
	return math.Sqrt(dx*dx + dy*dy)
}

// DistanceSquared 返回两个向量之间距离的平方
func (v Vec2) DistanceSquared(other Vec2) float64 {
	dx := v.x - other.x
	dy := v.y - other.y
	return dx*dx + dy*dy
}

// Lerp 返回两个向量之间的线性插值
func (v Vec2) Lerp(other Vec2, t float64) Vec2 {
	return Vec2{
		v.x + (other.x-v.x)*t,
		v.y + (other.y-v.y)*t,
	}
}

// Reflect 根据给定的法线向量计算反射向量
func (v Vec2) Reflect(normal Vec2) Vec2 {
	// 确保法线是单位向量
	n := normal.Normalize()
	// 反射公式: r = v - 2(v·n)n
	return v.Sub(n.Mul(2 * v.Dot(n)))
}

// Rotate 返回向量按指定角度（弧度）旋转后的向量
func (v Vec2) Rotate(angle float64) Vec2 {
	cos := math.Cos(angle)
	sin := math.Sin(angle)
	return Vec2{
		v.x*cos - v.y*sin,
		v.x*sin + v.y*cos,
	}
}

// Angle 返回向量与X轴正方向的夹角（弧度）
func (v Vec2) Angle() float64 {
	return math.Atan2(v.y, v.x)
}

// AngleBetween 返回两个向量之间的夹角（弧度）
func (v Vec2) AngleBetween(other Vec2) float64 {
	// 使用点积公式: cos(θ) = (a·b) / (|a|*|b|)
	// 为了避免除以零，先检查是否有零向量
	vLength := v.Length()
	oLength := other.Length()
	if vLength == 0 || oLength == 0 {
		return 0
	}
	cosTheta := v.Dot(other) / (vLength * oLength)
	// 确保cosTheta在[-1,1]范围内，避免浮点误差
	cosTheta = math.Max(-1, math.Min(1, cosTheta))
	return math.Acos(cosTheta)
}

// Equal 判断两个向量是否近似相等（考虑浮点误差）
func (v Vec2) Equal(other Vec2, epsilon float64) bool {
	return math.Abs(v.x-other.x) < epsilon && math.Abs(v.y-other.y) < epsilon
}

// IsZero 判断向量是否为零向量
func (v Vec2) IsZero() bool {
	return v.x == 0 && v.y == 0
}

// IsZeroApprox 判断向量是否近似为零向量（考虑浮点误差）
func (v Vec2) IsZeroApprox(epsilon float64) bool {
	return math.Abs(v.x) < epsilon && math.Abs(v.y) < epsilon
}

const c = @import("c.zig");
const std = @import("std");

pub const DirtyRect = extern struct {
    screen_width: c_int = 0,
    screen_height: c_int = 0,
    bounding_box: c.SDL_Rect = .{},

    pub fn init() DirtyRect {
        return .{};
    }

    pub export fn newDirtyRect() callconv(.C) ?*DirtyRect {
        return std.heap.c_allocator.create(DirtyRect) catch null;
    }

    pub export fn destroyDirtyRect(self: *DirtyRect) callconv(.C) void {
        std.heap.c_allocator.destroy(self);
    }

    pub export fn setDimension(self: *DirtyRect, width: c_int, height: c_int) callconv(.C) void {
        self.screen_width = width;
        self.screen_height = height;
    }

    /// 将输入的SDL_Rect矩形进行处理后合并到当前实例的包围盒中
    ///
    /// 注意坐标系，屏幕左上角为原点 (0,0)，右下角为 (w,h)。
    ///
    /// 包围盒不超过屏幕尺寸，不越过屏幕边缘。
    ///
    /// 参数:
    ///   self: *DirtyRect  - 当前实例指针，包含屏幕尺寸和当前包围盒信息
    ///   src: c.SDL_Rect   - 需要添加的源矩形，使用C语言兼容结构体格式
    pub export fn addRect(self: *DirtyRect, src: c.SDL_Rect) callconv(.C) void {
        var result = src;
        // 过滤无效矩形（宽度或高度为0的情况）
        if (result.w == 0 or result.h == 0) {
            return;
        }

        // src 不在屏幕范围内则不处理
        if (src.x + src.w <= 0 or
            src.x >= self.screen_width or
            src.y + src.h <= 0 or
            src.y >= self.screen_height)
        {
            return;
        }

        // 处理x坐标为负的情况：调整矩形左边界和宽度
        if (result.x < 0) {
            result.w += result.x;
            result.x = 0;
        }

        // 处理y坐标为负的情况：调整矩形上边界和高度
        if (result.y < 0) {
            result.h += result.y;
            result.y = 0;
        }

        // 处理右边界超出屏幕的情况
        if (result.x + result.w >= self.screen_width) {
            result.w = self.screen_width - result.x;
        }

        // 处理下边界超出屏幕的情况
        if (result.y + result.h >= self.screen_height) {
            result.h = self.screen_height - result.y;
        }

        // 合并处理后的矩形到当前包围盒
        self.bounding_box = calcBoundingBox(self.bounding_box, result);
    }

    pub export fn clear(self: *DirtyRect) callconv(.C) void {
        self.bounding_box.w = 0;
        self.bounding_box.h = 0;
    }

    pub export fn fill(self: *DirtyRect, w: c_int, h: c_int) callconv(.C) void {
        self.bounding_box.x = 0;
        self.bounding_box.y = 0;
        self.bounding_box.w = w;
        self.bounding_box.h = h;
    }
};

fn calcBoundingBox(src1: c.SDL_Rect, src2: c.SDL_Rect) c.SDL_Rect {
    if (src2.w == 0 or src2.h == 0) {
        return src1;
    }
    if (src1.w == 0 or src1.h == 0) {
        return src2;
    }

    var result = src1;
    if (result.x > src2.x) {
        result.w += result.x - src2.x;
        result.x = src2.x;
    }
    if (result.y > src2.y) {
        result.h += result.y - src2.y;
        result.y = src2.y;
    }
    if (result.x + result.w < src2.x + src2.w) {
        result.w = src2.x + src2.w - result.x;
    }
    if (result.y + result.h < src2.y + src2.h) {
        result.h = src2.y + src2.h - result.y;
    }

    return result;
}

test "init" {
    const d = DirtyRect.init();
    _ = d;
}

test "setDimension" {
    var d = DirtyRect.init();
    d.setDimension(10, 10);
    try std.testing.expectEqual(10, d.screen_width);
    try std.testing.expectEqual(10, d.screen_height);
}

test "calcBoundingBox" {
    const bounding_box = calcBoundingBox(.{ .x = 0, .y = 0, .w = 10, .h = 10 }, .{ .x = 5, .y = 5, .w = 10, .h = 10 });
    try std.testing.expectEqual(c.SDL_Rect{ .x = 0, .y = 0, .w = 15, .h = 15 }, bounding_box);
}

test "addRect" {
    var d = DirtyRect.init();
    d.setDimension(10, 10);
    d.addRect(.{ .x = 0, .y = 0, .w = 5, .h = 5 });
    d.addRect(.{ .x = 5, .y = 5, .w = 10, .h = 10 });
    try std.testing.expectEqual(c.SDL_Rect{ .x = 0, .y = 0, .w = 10, .h = 10 }, d.bounding_box);
}

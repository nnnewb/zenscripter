const c = @import("c.zig");

const handle = anyopaque;

pub const onscripter = opaque {
    pub fn open() ONScripterError!*onscripter {
        if (c.onscripter_open()) |ptr| {
            return @ptrCast(ptr);
        }
        return error.UnknownError;
    }

    pub fn close(self: *onscripter) ONScripterError!void {
        const err = c.onscripter_close(@ptrCast(self));
        if (err > 0) {
            return error.UnknownError;
        }
        return;
    }
};

const ONScripterError = error{
    UnknownError,
};

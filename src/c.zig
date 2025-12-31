const c = @cImport({
    @cInclude("version.h");
    @cInclude("onscripter_lib.h");
});

pub const NSC_VERSION = c.NSC_VERSION;

pub const ONS_VERSION = c.ONS_VERSION;

pub const onscripter_open = c.onscripter_open;

pub const onscripter_close = c.onscripter_close;

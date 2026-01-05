use anyhow::{Error, Result};
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{Once};

pub struct Engine {
    open_script_once: AtomicBool,
}

impl Engine {
    pub fn new() -> Self {
        Self {
            open_script_once: AtomicBool::new(false),
        }
    }

    pub fn open_script(self: &mut Self) {
        if self.open_script_once.load(Ordering::Relaxed) {
            panic!("call open_script more than one time is not allowed")
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn new_engine() {
        _ = Engine::new();
    }
}

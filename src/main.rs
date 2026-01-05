mod engine;

use clap::Parser;
use engine::Engine;

#[derive(Parser, Debug)]
#[command(name = "zenscripter")]
#[command(version = "0.1.0")]
#[command(about = "zenscripter is a toy project")]
struct Args {
    #[arg(long)]
    cd_audio: bool,
    #[arg(long)]
    cd_number: Option<i32>,
    #[arg(long)]
    font: Option<String>,
    #[arg(long)]
    registry: Option<String>,
    #[arg(long)]
    dll: Option<String>,
    #[arg(long)]
    root: Option<String>,
    #[arg(long)]
    fullscreen: bool,
    #[arg(long)]
    window: bool,
    #[arg(long)]
    force_button_shortcut: bool,
    #[arg(long)]
    enable_wheeldown_advance: bool,
    #[arg(long)]
    disable_rescale: bool,
    #[arg(long)]
    render_font_outline: bool,
    #[arg(long)]
    edit: bool,
    #[arg(long)]
    key_exe: bool,
}

fn main() {
    let parsed = Args::parse();
    let mut engine = Engine::new();

    println!("{:?}", parsed);
    println!("Hello, world!");
}

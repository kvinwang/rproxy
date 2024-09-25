mod handler;
mod io;
mod listener;
mod settings;

mod http;
mod tls;
mod tunnel;
mod error;

use futures::future::{join_all, try_join_all};
use settings::{build_listener, Settings};
use error::Error;
use clap::Parser;

#[derive(Parser)]
struct Args {
    #[arg(short, long, default_value = "config.yaml")]
    config: String,
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    let args = Args::parse();
    let settings = Settings::new(&args.config)?;

    let listeners = try_join_all(settings.servers.iter().map(build_listener)).await?;
    join_all(listeners.iter().map(|l| l.handle())).await;

    Ok(())
}

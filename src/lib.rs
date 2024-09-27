mod handler;
mod io;
mod listener;
mod settings;

mod error;
mod http;
mod tls;
mod tunnel;

use futures::future::{join_all, try_join_all};
use settings::{build_listener, Settings};

pub use error::Error;

pub async fn run(config_file: &str) -> Result<(), Error> {
    let settings = Settings::new(config_file)?;
    let listeners = try_join_all(settings.servers.iter().map(build_listener)).await?;
    join_all(listeners.iter().map(|l| l.handle())).await;
    Ok(())
}

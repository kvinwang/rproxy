use clap::Parser;
use rproxy::{run, Error};

#[derive(Parser)]
struct Args {
    #[arg(short, long, default_value = "config.yaml")]
    config: String,
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    tracing_subscriber::fmt::init();

    let args = Args::parse();
    run(&args.config).await
}

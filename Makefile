BIN=target/release/rproxy

$(BIN):
	cargo build --release

install: $(BIN)
	install -D -m 755 $(BIN) /usr/local/bin/rproxy
	install -D -m 644 rproxy.service /etc/systemd/system/rproxy.service
	mkdir -p /etc/rproxy
	cp config.simple.yaml /etc/rproxy/config.yaml
	mkdir -p /etc/rproxy/certs
	openssl req -x509 -newkey rsa:4096 -keyout /etc/rproxy/certs/key.pem -out /etc/rproxy/certs/cert.pem -days 365 -nodes -subj "/CN=localhost" -batch
	systemctl daemon-reload
	systemctl enable rproxy.service
	systemctl start rproxy.service

clean:
	cargo clean

.PHONY: install clean

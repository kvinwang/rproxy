BIN=target/release/rproxy

$(BIN):
	cargo build --release

install: $(BIN)
	install -D -m 755 $(BIN) /usr/local/bin/rproxy
	install -D -m 644 rproxy.service /etc/systemd/system/rproxy.service
	@if ! id rproxy >/dev/null 2>&1; then \
		useradd -r -s /sbin/nologin rproxy; \
	fi
	@if ! getent group rproxy >/dev/null 2>&1; then \
		groupadd -r rproxy; \
	fi
	systemctl daemon-reload
	systemctl enable rproxy.service
	systemctl start rproxy.service
	@echo "rproxy has been installed and started successfully."
	mkdir -p /etc/rproxy
	cp config.simple.yaml /etc/rproxy/config.yaml
	@echo "rproxy config file has been created successfully."
	mkdir -p /etc/rproxy/certs
	openssl req -x509 -newkey rsa:4096 -keyout /etc/rproxy/certs/key.pem -out /etc/rproxy/certs/cert.pem -days 365 -nodes -subj "/CN=localhost" -batch
	@echo "rproxy certs have been created successfully."

clean:
	cargo clean

.PHONY: install clean

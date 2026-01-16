BINARY ?= ut
PKG := ./cmd

GO ?= go
GOFLAGS ?=

GO_LDFLAGS ?= -s -w

.PHONY: all build build-local build-linux-amd64 build-linux-arm64 clean test fmt vet run-json run-json-post

all: build

build: build-local

build-local:
	$(GO) build $(GOFLAGS) -o $(BINARY) $(PKG)

build-linux-amd64:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GO) build $(GOFLAGS) -trimpath -ldflags "$(GO_LDFLAGS)" -o $(BINARY)_linux_amd64 $(PKG)

build-linux-arm64:
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 $(GO) build $(GOFLAGS) -trimpath -ldflags "$(GO_LDFLAGS)" -o $(BINARY)_linux_arm64 $(PKG)

test:
	$(GO) test ./...

fmt:
	$(GO) fmt ./...

vet:
	$(GO) vet ./...

clean:
	rm -f $(BINARY) $(BINARY)_linux_amd64 $(BINARY)_linux_arm64

run-json:
	./$(BINARY) -json -m 4 -f 0

# Example: make run-json-post URL=https://example.com/endpoint
run-json-post:
	@if [ -z "$(URL)" ]; then echo "URL is required: make run-json-post URL=https://example.com/endpoint"; exit 2; fi
	./$(BINARY) -json -m 4 -f 0 -url $(URL)

bindir := bin
server := ${bindir}/rover-server
cli := ${bindir}/rover-cli
worker := ${bindir}/rover-worker
binaries := ${bindir} ${server} ${cli} ${worker}
all: ${binaries}

.PHONY: server ${binaries} cli worker test
server: ${server}
cli: ${cli}
worker : ${worker}

${bindir}:
	mkdir -p $@/

${server}:
	CGO_ENABLED=0 go build -o $@ .

${cli}:
	CGO_ENABLED=0 go build -o $@ ./cmd/rover

${worker}:
	CGO_ENABLED=0 go build -o $@ ./worker/

run: ${binaries}
	docker-compose up -d --build db
	docker-compose up --build server cli
test:
	go clean -testcache
	go test ./test -v

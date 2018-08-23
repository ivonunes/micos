.PHONY: clean build test

all: build

clean:
	@rm -rf *.gz *.iso

build:
	@docker build -t microtux/builder .
	@docker run -i -t --name microtux_build microtux/builder
	@docker cp microtux_build:/build/work/build.iso .
	@docker rm -f microtux_build
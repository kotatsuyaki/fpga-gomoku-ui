.PHONY: build program clean
TOP = Top

build:
	mkdir -p build
	vivado -mode batch -source scripts/build.tcl \
		-log build/vivado-build.log -journal build/vivado-build.jou
	-notify-send -t 15000 "build done"

clean:
	rm -rf build

program:
	openocd -f ./scripts/basys3.cfg -c 'init; pld load 0 ./build/${TOP}.bit; exit'
	-notify-send -t 15000 "program done"

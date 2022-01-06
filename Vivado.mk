.PHONY: build program clean
TOP = Top

build:
	vivado -mode batch -source scripts/build.tcl
	-notify-send -t 15000 "build done"

clean:
	rm -rf build

program:
	openocd -f ./scripts/basys3.cfg -c 'init; pld load 0 ./build/${TOP}.bit; exit'

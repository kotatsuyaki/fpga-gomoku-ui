.PHONY: test
MAKE = make

test:
	verilator \
		--top Top \
		-Isrc \
		src/*.sv \
		--cc --exe testbench/Top.cpp \
		-CFLAGS "$(shell sdl2-config --cflags)" \
		-LDFLAGS "$(shell sdl2-config --libs)"
	$(MAKE) -C obj_dir -f VTop.mk
	cd ./obj_dir && ./VTop

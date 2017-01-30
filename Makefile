export IVERILOG_DUMPER:=lxt2

all:
	yosys -q -p "synth_ice40 -blif build/sha256.blif" main.v
	arachne-pnr -d 1k -P tq144 -p icestick.pcf -o build/sha256.txt build/sha256.blif
	icepack build/sha256.txt build/sha256.bin

flash:
	iceprog build/sha256.bin

clean:
	rm -f build/* *~

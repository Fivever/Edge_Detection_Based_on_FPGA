onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib origin_picture_rom_opt

do {wave.do}

view wave
view structure
view signals

do {origin_picture_rom.udo}

run -all

quit -force

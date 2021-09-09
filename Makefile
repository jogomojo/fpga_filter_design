all: sysgen vivado

.PHONY: sysgen
sysgen:
	make -C ./sysgen

.PHONY: vivado
vivado:
	make -C ./vivado

.PHONY: clean
clean: clean_sysgen clean_vivado

clean_sysgen:
	make -C ./sysgen clean

clean_vivado:
	make -C ./vivado clean

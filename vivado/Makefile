VIVADO_VERSION := 2019.1

all: checkenv
	vivado -mode batch -notrace -nojournal -nolog -source filter_designer_project.tcl

checkenv:
	vivado -version | fgrep $(VIVADO_VERSION)

.PHONY: clean
clean:
	rm -rf filter_designer

MATLAB_VERSION := R2018b
SYSGEN_VERSION := 2019.1

all: checkenv
	sysgen -nodesktop -r "run('./GenerateIP.m')"

.PHONY: checkenv
checkenv:
	matlab -n | grep "MATLAB              = .*/R2018b" | fgrep $(MATLAB_VERSION)
	command -v sysgen | fgrep $(SYSGEN_VERSION)

.PHONY: clean
clean:
	rm -rf iprepo slprj FilterDesigner.slxc *.log

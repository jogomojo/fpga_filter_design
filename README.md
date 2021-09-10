# A Natively Fixed-Point Runtime Reconfigurable FIR Filter Design Method for FPGA Hardware

This repository contains the design files required to build a natively fixed-point FIR Filter Designer for the PYNQ-Z2 development board. The Filter Designer uses a hybrid of window and frequency sampling design methods to create an algorithm that can both, design linear-phase coefficients entirely in fixed-point arithmetic, and program reconfigurable FIRs on-the-fly and at runtime. This method of filter design is compelling as it removes the need for off-chip programming (which can be slow and require a large hardware footprint) and is well suited to SDR applications.

The Filter Designer requires five input parameters to operate. Four are set at IP generation: filter length, FFT length, window type, and output wordlength; and one set at run-time: the cutoff frequency. The demonstration design is set up to generate low pass filters only, and the cutoff frequency is set by writing to a shared AXI-Lite register from the Zynq Arm processor. With that said, it is possible to modify the design to generate any arbitrary frequency response.

The project files included in this repository build exclusively for the PYNQ-Z2 development board, however, the demonstration can be built for any ZYNQ or ZYNQ Ultrascale+ board that can run the PYNQ operating system, with only minor adjustments. Additionally, the Filter Designer IP can be easily modified for operation on any Xilinx 7-series FPGAs.

## Prerequisites
- [Vivado 2019.1](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive.html)
- [System Generator 2019.1](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive.html)
- [MATLAB R2018b](mathworks.com/)
- [PYNQ-Z2 Development board](https://www.tul.com.tw/ProductsPYNQ-Z2.html) running [PYNQ v2.5](https://dpoauwgwqsy2x.cloudfront.net/Download/pynq_z2_v2.5.zip) (or higher)
- [PYNQ-Z2 board files](https://dpoauwgwqsy2x.cloudfront.net/Download/pynq-z2.zip) installed to the Vivado path
- [Ubuntu 18.04 LTS](https://releases.ubuntu.com/18.04/)

## Quick Start
Clone this repository to your Linux computer and change directory into it.
```
git clone https://github.com/jogomojo/fpga_filter_design.git
cd fpga_filter_designer
```
Run the Makefile.
```
make
```
Boot up your PYNQ board and navigate to Jupyter Lab by entering the board's IP address into your web browser.
```
<board_ip_address>/lab
```
Copy the ```overlay``` directory and its contents to the board.

Open the notebook and run the cells.

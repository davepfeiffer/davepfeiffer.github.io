

# Programming FPGAs is NOT Hardware Description

The original [purpose of verilog]() was to be a simulation language. People would mock up a design in verilog, check if it worked, then layout the chip by hand. Further down the line someone had the (legitimately) clever idea of writing an algorithm to handle all that boring work. I image it was huge improvement and there was much rejoicing. Then FPGAs got popular.

Verilog simply just starts to fall apart when working with FPGAs. This is because configuring an FPGA is __NOT__ hardware description. The hardware for any given FPGA is already described, verified, laid out, set in stone. The only thing that can be changed is how the data flows through the given transistors. It requires extensive knowledge of hardware and feels a lot like traditional digital design, but that's only a testiment to the skill of all the engineers who have worked on synthesis/place and route. There are so many things you can do in an ASIC that are horribly inefficient or just broken if put into an FPGA design. Including:

- [Gating clocks]()

- [Asynchronous design]()

- 

Verilog and other hardware description languages are so far from FPGA architecture that mapping them onto a device is an NP problem. 


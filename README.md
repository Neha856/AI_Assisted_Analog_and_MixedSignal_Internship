# Digital VLSI SoC Design and planning

<details>

<summary>DAY 1 - Inception of Open-Source EDA, OpenLANE & Sky130 PDK  </summary>


# Section 1 - How to talk to computers 
## Lec1 : Introduction to QFN-48 Package, chip, pads, core, die and IPs
### What is Package 

- In digital SoC design, a **package** is the physical outer body of the IC chip that protects the silicon die and provides pins/connections to the PCB.
- It determines how the chip is mounted, connected, cooled, and handled in hardware systems.
Example - **QFN48** means Quad Flat No-lead package with 48 pins.

`Quad Flat` → pins/connections are on all four sides.
`No-lead` → there are no long external leads; pads are underneath the package.
`48` → total number of electrical connections/pins.

- QFN packages are popular because they are compact, have good thermal performance, and are suitable for high-speed digital designs.

### What is Chip,Pads, core and die

- **Chip** : The final integrated circuit (IC) product used on a PCB/system. It contains electronic circuits for processing, control, memory, etc.
- **Die**  : The small silicon piece inside the chip where the actual transistors and circuits are fabricated. One wafer contains many dies.
- **Pads** : Metal connection points on the die boundary used to connect internal circuits to external **package** pins for signals, power, and ground.
- **Core** : The main functional block inside the die, such as a CPU core, processor core, or DSP core that performs computations and logic operations.

  ![image alt](https://github.com/Neha856/SoC_Design/blob/97f80eabe5534aeaf75e0e8568fe102e50d0a392/Screenshot%202026-05-15%20090510.png)

### What is Foundry, IPs, Foundry IPs and Macros

- **Foundry**: A foundry is the company that manufactures semiconductor chips from the design files. like TSMC, Samsung Electronics, and GlobalFoundries.
- **IP (Intellectual Property)**: IPs are pre-designed reusable circuit blocks used in SoC design instead of designing everything from scratch. Examples: UART, SPI, USB, DDR controller, PLL, CPU core.
- **Foundry IPs**: These are IP blocks provided or qualified by the foundry for a specific technology node.It has a intelligent technique. Common examples are: Standard cells, SRAM, I/O cells, PLL, ESD cells.
- **Macros**: Macros are large pre-designed physical blocks used during floorplanning and layout. They usually have fixed size and placement constraints and it is a pure digital logic. Examples: SRAM macro, ROM macro, Analog blocks, PLL macro.

![image alt](https://github.com/Neha856/SoC_Design/blob/00ca96ded73767c8a2cff0b590671167f70150f8/Screenshot%202026-05-15%20090952.png)


## Lec2 : RISCV Introduction
### What is RISC-V?

RISC-V is an **open-standard processor architecture** based on the **Reduced Instruction Set Computer (RISC)** concept which is simple and modular architecture. It is easy to customize and Supports 32-bit, 64-bit, and 128-bit processors. It defines how a processor understands and executes instructions, similar to architectures like ARM Holdings ARM or Intel x86, but RISC-V is open and royalty-free.

## What is a RISC-V Instruction Set?

instruction set architecture (ISA) is the collection of commands a processor can execute.These instructions tell the CPU what operation to perform.

Examples of RISC-V instructions:

```text
ADD   -> addition
SUB   -> subtraction
LW    -> load word from memory
SW    -> store word to memory
BEQ   -> branch if equal
JAL   -> jump and link
```

### Common RISC-V Base Architectures

* **RV32I** → 32-bit integer base ISA
* **RV64I** → 64-bit integer base ISA
* **RV32/64IM** → includes multiplication/division
* **RV32/64IMAFD** → floating-point support.

## Lec3 : From software Application to hardware
### What inside between user and hardware

- **Application Software Layer** : Application software is used directly by the user to perform tasks. like browser, Word, PDF reader, Excel, Virtual box etc. Applications are written in high-level languages like C, C++, Java.
 **Input** : User commands/actions
 **Output** : High-level program written in: C, C++,Java, Python.

![image alt](https://github.com/Neha856/SoC_Design/blob/a6132d1a286d71da2ac6ca3e92bd1f7ab6f378a4/Screenshot%202026-05-15%20092410.png)

- **System Software Layer** : This has Operating system, compiler and Assembler.
  - **Operating System** : The Operating System (Windows/Linux) manages files, IO devices, Memory allocation, Process scheduling and Device control. The output                              of OS is Provides APIs(Application programming interface)/system calls to applications.
  - **Compiler Stage**   : Compiler converts high-level language into assembly related instructions. example RISCV ISA, x86 ISA etc. This ISA is important                                   because Software does NOT directly know transistor-level hardware. It only knows ISA instructions like: ADD, SUB,LOAD, STORE, JUMP etc.
  - **Assembler Stage**  : Assembler converts assembly instructions into binary machine code(.bin). Example: ADD R1,R2 becomes: 101100101001.

- **Hardware** : Hardware/processor executes this binary code physically using logic gates and transistors. It contains: ALU,Registers,Memory, Control Unit, Interconnects,Transistors. HDL languages like Verilog and VHDL are used separately by hardware engineers to design the processor hardware itself.The output of hardware is Actual physical operations like Arithmetic,Memory access,Signal generation,Display/output control etc.

![image alt](https://github.com/Neha856/SoC_Design/blob/a6132d1a286d71da2ac6ca3e92bd1f7ab6f378a4/Screenshot%202026-05-15%20092946.png)

# Section 2 - SoC Design and OpenLANE
## Lec1 : Introduction of all components of open source digital ASIC Design
### Opensource Digital ASIC Design 

ASIC is a custom chip designed for a specific application or function. They needed three things:
- **1.RTL Designs** : RTL means **Register Transfer Level** design. This is the hardware functionality written using HDL languages like: Verilog, VHDL,  SystemVerilog.RTL describes logic, registers, FSM, datapath, processor blocks etc. The ouput is RTL code (.v, .sv).

- **2.EDA Tools** : EDA means **Electronics Design Automation**. These are software tools used to convert RTL into actual chip layout. Examples are OpenROAD, OpenLANE, Qflow. Commercial EDA tools: Cadence Design Systems, Synopsys, Siemens (Mentor Graphics) etc.  EDA tools perform: Synthesis, Floorplanning, Placement, Clock Tree Synthesis, Routing,Timing analysis, DRC/LVS verification etc.The ouput of EDA tools is  physical layout (GDSII).

- **3.PDK Data** : PDK means **Process Design Kit**.This is the technology information provided by the foundry. It contains: transistor models, design rules, standard cells, SPICE models, layer information, DRC/LVS rules. Without PDK tools do not know fabrication rules and chip cannot be manufactured correctly. PDK is the bridge between design and fabrication technology.

![image alt](https://github.com/Neha856/SoC_Design/blob/3c8612f982bb6a2e0474979b7e1825f27431f6b7/Screenshot%202026-05-15%20094629.png)

#### Why Open Source?
Earlier ASIC design was expensive because of commercial EDA tools cost huge money and foundry PDKs were closed/private. Open-source movement provides:
 free RTL cores, free EDA tools and open PDKs.This helps students, researchers, startups learning ASIC design.
 Examples: OpenROAD, OpenLANE, SkyWater PDK, RISC-V cores.

#### What is 130nm? Is 130nm still used? Is 130nm fast?

- 130nm is a semiconductor technology node. It roughly represents transistor size. 
- Yes, still used in many areas because cheaper manufacturing, easier fabrication, reliable good for analog/mixed-signal suitable for education and research. Used in microcontrollers, sensors, automotive, power ICs academic ASIC projects.But for AI processors, mobile CPUs, high-performance chips advanced nodes like: 7nm, 5nm, 3nm are used.
- It is fast but not very fast compare to modern nodes but simpler, more suitable and easier to design and good for learning ASIC Flow.


#### ASIC Design Flow

```text
Specification
    ↓
RTL Design (Verilog/VHDL)
    ↓
Functional Verification
    ↓
Synthesis
    ↓
Gate-Level Netlist
    ↓
Floorplanning
    ↓
Placement
    ↓
Clock Tree Synthesis
    ↓
Routing
    ↓
DRC/LVS Checks
    ↓
GDSII Layout
    ↓
Fabrication at Foundry
    ↓
Packaged Chip
```

## Lec2 : Simplified RTL2GDS Flow

![image alt](https://github.com/Neha856/SoC_Design/blob/e103318e668825ed5329ff25b3f162d11c2ff586/Screenshot%202026-05-16%20123414.png)

### Synthesis (Synth)

* Synthesis converts RTL code into a gate-level netlist using logic gates like AND, OR, flip-flops, and multiplexers.
* The synthesis tool optimizes the design for area, timing, and power based on constraints.
* It maps the RTL logic to standard cells available in the PDK library.
* After synthesis, the design becomes hardware-realistic instead of behavioral code.
* Output of synthesis is a gate-level netlist.

![image alt](https://github.com/Neha856/SoC_Design/blob/47163e27ed3a6e8061f74ce175d52cdababe1fd8/Screenshot%202026-05-16%20123640.png)

### FP + PP (Floorplanning + Power Planning)

* Floorplanning decides the physical arrangement of macros, memories, IO pins, and standard-cell regions inside the chip.
* Power planning creates power and ground networks to supply stable voltage across the design.
* This stage determines chip size, utilization, routing space, and overall layout structure.
* Good floorplanning improves timing, congestion, and power distribution.
* It is one of the most important stages in physical design.

### Placement

* Placement positions all standard cells into legal locations inside the floorplan.
* The tool tries to minimize wirelength, timing delay, and congestion.
* Cells are arranged close to related logic blocks for better performance.
* Only component locations are decided here; connections are not completed yet.
* Proper placement helps achieve timing closure and easier routing.

![image alt](https://github.com/Neha856/SoC_Design/blob/f6bcf7d82cefb4e8569307c279bd6d96f3613e2f/Screenshot%202026-05-16%20123842.png)

### CTS (Clock Tree Synthesis)

* CTS builds the clock distribution network inside the chip.
* Buffers and clock cells are inserted so the clock reaches all flip-flops with minimum skew and delay.
* The goal is to distribute the clock evenly across the design.
* Poor clock distribution can cause setup and hold timing violations.
* CTS is critical because almost all sequential circuits depend on the clock signal.

### Routing

* Routing creates the physical metal connections between all placed cells and blocks.
* The router uses different metal layers defined in the PDK to connect signals, clock, power, and ground.
* It ensures there are no shorts, opens, or rule violations.
* After routing, the chip layout becomes physically complete.
* This stage produces the detailed interconnection structure of the ASIC.

### Sign Off

* Sign-off is the final verification stage before chip fabrication.
* Engineers check timing, power, DRC, LVS, signal integrity, and manufacturability.
* The design must satisfy all foundry and functional requirements.
* If errors are found, the design goes back for fixes.
* After successful sign-off, the final GDSII file is generated for fabrication.

### GDSII

* GDSII is the final layout file sent to the foundry for manufacturing.
* It contains all geometric information of transistors, metal layers, vias, and routing.
* This file represents the complete physical chip layout.
* Foundries use GDSII data to create masks for semiconductor fabrication.
* It is the final output of the ASIC physical design flow.

## Lec3 : Introduction of OpenLANE and Strive chipsets
### OpenLANE 

OpenLANE is an open-source automated ASIC physical design flow. It connects multiple EDA tools together to convert RTL code into a GDSII chip layout automatically. It performs stages like:Synthesis, Placement, CTS, Routing, Signoff. It is mainly used with the SkyWater 130nm open-source PDK.


### StriVe

It is a reference/open-source SoC platform used for learning and prototyping ASICs. In simple word StriVe is a ready-made chip platform/template where designers can plug in their own hardware design. StriVe provides processor subsystem, memory interface, GPIO, integration framework, So users can directly add their own RTL block into a working chip environment.

![image alt](https://github.com/Neha856/SoC_Design/blob/834162d834e5814948947cdbc10b7020e196dcb5/Screenshot%202026-05-16%20150339.png)


#### Simple Difference

```text
| OpenLANE                   | StriVe                        |
| -------------------------- | ----------------------------- |
| ASIC design flow/tool      | Ready-made SoC platform       |
| Converts RTL to layout     | Provides chip framework       |
| Physical design automation | Hardware integration template |
| Used during implementation | Used during SoC development   |
```


## Lec4 : Introduction of OpenLANE detailed ASIC design flow

![image alt](https://github.com/Neha856/SoC_Design/blob/834162d834e5814948947cdbc10b7020e196dcb5/Screenshot%202026-05-16%20150620.png)


- **Synthesis Exploration** : Synthesis exploration tries different synthesis settings to improve timing, area, and power. It helps find the best optimized gate-level implementation from RTL. Tools mainly adjust mapping, constraints, and optimization strategies.

![image alt](https://github.com/Neha856/SoC_Design/blob/e96a1e62ed8cb6f78e06a457e56afef60265a513/Screenshot%202026-05-16%20152829.png)


- **Design Exploration** : Design exploration checks different floorplans, utilization, placement, and routing possibilities.It helps identify the best chip architecture and physical implementation setup.The goal is to improve performance, congestion, timing, and chip area.


- **OpenLANE Regression Testing** : Regression testing verifies that OpenLANE flow works correctly after tool or script updates. Many test designs are run automatically to check whether outputs still meet expected results. It ensures flow stability and avoids introducing new errors.

- **DFT (Design for Testability)** : DFT adds extra test structures into the design to make chip testing easier after fabrication. Common techniques are scan chains, scan flip-flops, and BIST. It helps detect manufacturing defects and improves test coverage.

![image alt](https://github.com/Neha856/SoC_Design/blob/e96a1e62ed8cb6f78e06a457e56afef60265a513/xmyCD0IjNOtSfyytkBLidf4MmUmiie4AGvqi8xGlS0z9XAy2fOrWmLiNOjo-M82QKDD-pT7ZUHDOENUKsrgCxurpOoAuGdJtxx_Ac13DyEIMgVv63oo8H03039P3uU8ysyTTPq0T_9qJd8HDuRLbNJ7wCHWN45mpyGZGh62Ygk_U9Sl9PNK4zy4tUmU4xKxv.jpg)

- **Placement Implementation/PnR (Place and Route)** : PnR is the physical implementation stage where cells are placed and connected using metal routing.
Placement decides cell locations, and routing creates physical interconnections.Final chip layout is generated during this stage.

- **LEC (Logical Equivalence Check)** : LEC checks whether two versions of a design are logically equivalent. Usually RTL is compared with synthesized netlist to ensure functionality is unchanged. It verifies synthesis did not introduce logic errors.

- **Antenna Rule Violations** : During fabrication, long metal wires can accumulate charge and damage transistors.  Antenna violation fixing inserts antenna diodes or changes routing to safely discharge the charge.This protects gate oxide from fabrication damage.

- **STA with RC Extraction** : STA (Static Timing Analysis) checks setup/hold timing without simulation. RC extraction calculates wire resistance (R) and capacitance (C) after routing. Using extracted RC values gives accurate delay and timing analysis.

- **Physical Verification** : Physical verification ensures the layout is manufacturable and matches the intended design. It mainly includes DRC, LVS, antenna checks, and layout verification. This is one of the final stages before tapeout.

- **DRC (Design Rule Check)** : DRC checks whether the layout follows foundry manufacturing rules from the PDK. Examples include spacing, width, enclosure, and metal overlap rules. Any DRC violation can cause fabrication failure.

- **LVS (Layout Versus Schematic)** : LVS compares the physical layout with the original circuit/netlist. It checks whether all connections and devices match correctly. LVS ensures the fabricated layout implements the intended circuit design exactly.


# Section 3 - Get familiar to open-source EDA tools
## Lec1 : OpenLANE Directory structure 
### OpenLane Directory Structure

OpenLane has folders for:

* `designs/` → user chip designs like picorv32a
* `scripts/` → automation scripts
* `runs/` → output files after synthesis, floorplan, placement, routing
* `pdks/` or `.ciel/` → technology files and standard cell libraries.

### PDK (Process Design Kit)

PDK is a collection of files provided by foundry to manufacture chips. It contains technology rules, transistor models, standard cells, LEF/GDS files, timing data, etc. Without PDK, tools do not know how to build the chip physically. They have three pdk folder

- **skywater-pdk:**  SkyWater is the foundry/company. SkyWater PDK is the open-source 130nm manufacturing technology released by Google + SkyWater.
- **sky130A:** sky130A is one specific version/variant of the Sky130 technology files used by OpenLane. It contains libraries, rules, timing, LEF, Magic tech files, SPICE models, etc.
- **OpenPDKs:** OpenPDKs converts raw foundry data into tool-compatible format. It prepares files for Magic, Netgen, OpenROAD, KLayout, etc.

#### libs.ref

Contains actual physical library data like GDS, LEF, SPICE, Verilog models. Used as reference libraries during design flow. It is related to technology used.

#### libs.tech

Contains tool-specific technology files like Magic tech files, KLayout rules and extraction rules etc. Used by EDA tools to understand process rules.

#### LEF File (Library Exchange Format)

LEF gives physical abstract information like cell width/height, pin locations, routing blockages, metal layers. Used during floorplan and placement.

#### DEF File (Design Exchange Format)

DEF file stores the physical implementation information of the chip design after floorplanning/placement/routing. It contains: cell placements, pin locations, routing connections, floorplan dimensions, metal wire information. DEF does NOT contain transistor-level layout shapes like GDS. It is mainly used by EDA tools to transfer placement and routing data between tools.

#### Tech File

Technology file defines fabrication rules like layer names, spacing rules, widths, vias, DRC rules. EDA tools use it to create manufacturable layouts.


#### Process Corners

Process corners represent manufacturing variations like `fast`, `slow`, `typical` and their combination. They help check chip timing under different conditions because real chips are never perfectly identical.


## Lec2 : Design Preparation Step
### LAB : Setting Up Codespace, Invoking OpenLANE and Running OpenLANE for picorv32a

 - **1.** The very first step is to navigate to the OpenLANE working directory and starts the OpenLane Docker container and mounts/connects your local OpenLane files, PDKs, and workspace directories inside the container environment.
  
```bash
cd ~/Desktop/OpenLane
make mount
```
 - **2.** Starts OpenLane in interactive TCL mode. This allows you to manually run commands step-by-step. Without `-interactive`, OpenLane runs the complete flow automatically from synthesis to routing in one shot and then Loads the OpenLane TCL package/version into memory. It enables all OpenLane commands.
  
```bash  
./flow.tcl -interactive
package require openlane 1.0.2
```

 - **3.** Prepares the design environment for the selected design. It reads config.tcl, loads RTL files, loads PDK and libraries, creates run directory, prepares LEF/library files for flow execution also OpenLane prepares and merges LEF files from standard cell libraries and technology LEFs into a single merged LEF file (`merged.nom.lef`) used later by floorplan, placement, and routing tools.

  ```tcl
prep -design picorv32a
```

![image alt](https://github.com/Neha856/SoC_Design/blob/14f837c848a55b775ffa3c5e522d8fa270e95e65/Screenshot%202026-05-16%20214243.png)

## Lec3 : Review files after design prep and run synthesis 
### Running Synthesis

```tcl
run_synthesis
```
![image alt](https://github.com/Neha856/SoC_Design/blob/24caba66c092c8214e7564dc7c0e02836cabaac2/Screenshot%202026-05-16%20222940.png)

After Synthesis my picorv.def file is not visible in vsd explorer so i have used below command.

![image alt](https://github.com/Neha856/SoC_Design/blob/d0dd7188427661ad3a47cd45a325f1f75e9b9498/Screenshot%202026-05-16%20222154.png)

### What is config.tcl

This is the main design configuration file. It contains design name, clock period, Verilog source files, PDK/library settings, floorplan parameters, synthesis and routing settings. It tells OpenLane how to process the design.



## Lec4 : OpenLANE Project Git Link Description

OpenLane automates the complete physical design flow like synthesis, floorplanning, placement, clock tree synthesis, routing, DRC/LVS checks. The GitHub repository contains OpenLane scripts, flow automation, sample designs, Docker setup, configuration files, tutorials and documentation.

[Efabless OpenLane GitHub Repository](https://github.com/The-OpenROAD-Project/OpenLane?utm_source=chatgpt.com)

[Watch Video](https://www.youtube.com/playlist?list=PLUg3wIOWD8yoZCg9XpFSgEgljx6MSdm9L)


## Lec5 : Steps to characterize synthesis results 
After synthesis completes, we can calculate the **flop ratio** — a useful sanity check. Helps understand how much sequential logic is present in design.
Higher flop ratio usually increases clock network complexity and power. 

![image.alt](https://github.com/Neha856/SoC_Design/blob/24caba66c092c8214e7564dc7c0e02836cabaac2/Screenshot%202026-05-16%20223035.png)

```text
Flop Ratio = (No. of D Flip-Flops) / (Total No. of Cells)
           = 1613 / 15762
           ≈ 0.1023  →  ~10.23%
```

</details>

<details> 
	<summary> DAY 2 - Good floorplan vs bad floorplan and introduction to library cells </summary>

# Section 1 - How to talk to computers 
## Lec1 : Chip Floor planning considerations
### Utilization factor and aspect ratio 

- **Utilization Factor:** Utilization factor tells how much chip core area is occupied by standard cells. Helps decide free space available for routing. Very    high utilization causes congestion and routing problems and Very low utilization wastes chip area.Typical value: 50% – 70%.
                         **Utilisation Factor** = (Area occupied by Netlist) / (Total Core Area) 

- **Aspect Ratio:** Aspect ratio is the ratio of core height to core width.Decides overall chip/core shape, Affects routing efficiency and placement quality. Aspect ratio `1` means square core. Non-square shapes may help some designs fit better(we can add buffer here).
                         **Aspect Ratio** = Height / Width of the core

Below flow describes the process of defining width and height of core and Die.**Netlist:** Describes connectivity of Electronics design.
![image alt](https://github.com/Neha856/SoC_Design/blob/9dd8145eef251e98c548bc957f00279636ead7d0/Presentation1.png)

## Lec2 : Concept of pre-placed cells
Pre-placed cells are fixed cells/IP or macros(Memory block, clk gating cell, comparator, MUX, power managment block) whose locations are decided before automatic placement and routing starts.The placer cannot move these cells during placement. The benifit is that it is implemented once and can be instantiate multiple times during floorplanning.

## Lec3 : De-coupling capacitors
- **Wire Loss:** Wire loss means power or signal degradation occurring in interconnect wires because wires have resistance and capacitance.
- **Switcing current:** Switching current is the transient current drawn when transistors change state (`0→1` or `1→0`). During switching many gates draw sudden current from power supply and creates voltage fluctuations and noise.
- **Noise Margin Range:** Noise margin tells, the maximum unwanted noise voltage a digital circuit can tolerate without changing logic. Higher noise margin means better reliability and less chance of logic error due to noise.
                  **NM(Noise margin) = (NM_H - NM_L)**
- **Disadvantage of Large Distance from Main Power Supply:** If a block is far from power source then the power wire resistance increases, IR drop increases, switching noise becomes larger, timing failures may occur and also create delay, wrong logic at output.
- **How Decoupling Capacitor Solves This:** Decoupling capacitor (decap) acts like a local temporary charge storage near the circuit block. When sudden switching current is needed decap quickly supplies current locally, reduces voltage drop, stabilizes VDD/GND and reduces noise and power fluctuations.So decaps improves power integrity, noise stability and reliable switching.

  ![image alt](https://github.com/Neha856/SoC_Design/blob/d0b88032899513d1fc604aef97ccb5c3fe99dd60/Presentation2.png)
  

## Lec4 :  Power planning
Till now we have resolved current demand of each elements/ckt within the block using de-cap. Now suppose same blocks(IP/Macro) is used multiple times in a chip and want to receive signal from Driver to Load Macro. Suppose one power supply is given to all. here its not possible to fit decoupling capacitor all over the chip, Multiple VDD and VSS rails are distributed in both metal layers so that every standard cell has a nearby power tap, minimising IR drop and electromigration risk.
![image alt](https://github.com/Neha856/SoC_Design/blob/3086b73b955b8a8a5d1c0285dad780b89d495485/Presentation3.png)


## Lec5 : Pin placement and logical cell placement blockage
![image alt](https://github.com/Neha856/SoC_Design/blob/e93f9c7cd6738ce9dda5c236055ec289f5a67b7f/Presentation5.png)


## Lec6(LAB) :  Steps to run floorplan using OpenLANE
### Floorplan and Switches 
**Floorplanning** is the stage in ASIC design where the chip/core layout structure is decided before placement. It defines core size, macro locations, IO pin locations, power distribution, routing space.Standard cells are **not placed** during floorplan. Good floorplan reduces congestion, delay, and power issues.

**Switches** Here “switches” means OpenLane configuration variables/options that `control flow behavior` during synthesis, floorplan, placement, CTS, routing, etc and passed during runtime. Example: Change synthesis optimization strategy.

```tcl 
set ::env(SYNTH_STRATEGY) "DELAY 1"
```
Examples of some switches are below 

   - **Synthesis Switches:** These control RTL → gate-level conversion. Examples

```text
  SYNTH_STRATEGY → optimize for area or delay
  SYNTH_BUFFERING → enable buffer insertion
  SYNTH_SIZING → resize cells for timing
  SYNTH_MAX_FANOUT → limit number of loads on output.
```

   - **Floorplanning Switches:** These control chip size and macro arrangement. Examples:

```text
 FP_CORE_UTIL → utilization percentage
 FP_ASPECT_RATIO → height/width ratio
 FP_IO_MODE → IO pin placement style
 FP_PDN_ENABLE_RAILS → enable power rails.
```

 ![image alt](https://github.com/Neha856/SoC_Design/blob/44d235590b7c24bf5e76309c9a7c71b7a024b999/Presentation7.png)
 
#### Running Floorplan

```text
run_floorplan
```


## Lec6(LAB) :  Review floorplan files and steps to view floorplan

After running floorplan, we can inspect the DEF file that was generated:

```bash
cd ~/Desktop/OpenLane/designs/picorv32a/runs/RUN_2026.05.16_16.07.42/results/floorplan
less picorv32a.def
```
## Lec(LAB)8 - Review floorplan layout in Magic

```bash
magic -T /home/vscode/.ciel/sky130A/libs.tech/magic/sky130A.tech
```
![image alt](https://github.com/Neha856/SoC_Design/blob/df47d583fb0983e2d047984941e9ab3a311ca7b8/Presentation6.png)

After that opening vnc website port and writing below command in tkcon window.
```tcl
lef read ../../tmp/merged.nom.lef
def read picorv32a.def
```
![image alt](https://github.com/Neha856/SoC_Design/blob/df47d583fb0983e2d047984941e9ab3a311ca7b8/Screenshot%202026-05-17%20213321.png)
![image alt](https://github.com/Neha856/SoC_Design/blob/df47d583fb0983e2d047984941e9ab3a311ca7b8/Screenshot%202026-05-17%20213706.png)


# Section 2 - Library Binding and Placement
## Lec1 : Netlist binding and initial place design

* **Netlist binding** means mapping logical gates in RTL/netlist to real physical standard cells and these physical standard cells are usually rectangular for easy placement and routing in rows.
* A **library** is a collection of pre-designed cells like AND, OR, DFF, buffers, etc. Library contains timing, power, layout, and pin information of each cell.
* Same **logic cell** can exist in multiple sizes/drive strengths such as `and2_1`, `and2_2`, `and2_4`. Bigger cells use larger transistors, giving lower resistance hence faster switching, but they consume more area and power.
* Once we have given proper sizes and shapes to each and every gates , the **next step** is to take those cells and placed on the floorplan.
  ![image alt](https://github.com/Neha856/SoC_Design/blob/9506486c2096b6b7aaf9cf6c34535bd3d6e688fa/Presentation8.png)

## Lec2 : Optimize placement using estimated wire-length and capacitance

Before routing **Placement** is optimized using estimated wire length and capacitance to reduce delay and maintain signal integrity. Long interconnects weaken signals and increase RC delay. Buffers/repeaters are inserted between long paths to restore and strengthen signals step-by-step. This improves timing and signal quality but increases chip area and power consumption.

## Lec3 : Final placement optimization

![image alt](https://github.com/Neha856/SoC_Design/blob/b2c479c123c9fa84972b28d0b20e4679c9570ef6/Presentation9.png)


## Lec4 : Need for libraries and characterization

* After synthesis, floorplanning, and placement, libraries are needed to provide accurate timing, power, and noise information of standard cells for STA and optimization. **A standard cell library** is a collection of pre-designed logic cells containing layout, timing, power, and functional information used during ASIC design.
* **Power characterization** measures how much dynamic and leakage power each cell consumes under different conditions. **Noise characterization** analyzes how cells behave under signal noise/crosstalk to ensure reliable logic operation and proper noise margins.
* **NLDM (Non-Linear Delay Model)** stores delay and transition values in lookup tables based on input slew and output load capacitance.
* **CCS (Composite Current Source)** is an advanced timing/power/noise model that represents real current behavior of cells more accurately than NLDM for high-speed designs.


## Lec5 : Congestion aware placement using RePlAce

### Legalization and Types of Placement 

Legalization is the process of adjusting placed standard cells into valid rows/sites without overlaps after global placement. It ensures all cells follow placement rules while keeping displacement and timing impact as small as possible.Types of placement are 

* **Global Placement** → Cells are placed approximately in the chip area to minimize wire length and congestion without exact legal positions.
* **Detailed Placement** → Cells are moved to exact legal rows/sites while fixing overlaps and improving placement quality.
* **Timing-Driven Placement** → Placement is optimized mainly to improve timing and reduce critical path delay.
* **Congestion-Driven Placement** → Cells are arranged to reduce routing congestion and improve routability.

### Running Placement

```tcl
run_placement
```
![image alt](https://github.com/Neha856/SoC_Design/blob/df47d583fb0983e2d047984941e9ab3a311ca7b8/Screenshot%202026-05-17%20221445.png)

After this completes, we can inspect the DEF file that was generated:

```bash
cd ~/Desktop/OpenLane/designs/picorv32a/runs/RUN_2026.05.17_16.30.19/results/placement
less picorv32a.def
```

#### Viewing the placement in Magic
```bash
magic -T /home/vscode/.ciel/sky130A/libs.tech/magic/sky130A.tech
```
After that opening vnc website port and writing below command in tkcon window.
```tcl
lef read ../../tmp/merged.nom.lef
def read picorv32a.def
```
![image alt](https://github.com/Neha856/SoC_Design/blob/df47d583fb0983e2d047984941e9ab3a311ca7b8/Screenshot%202026-05-17%20221751.png)
![image alt](https://github.com/Neha856/SoC_Design/blob/df47d583fb0983e2d047984941e9ab3a311ca7b8/Screenshot%202026-05-17%20222200.png)


# Section 3 - Cell design and characterization flows 
## Lec1 : Inputs for cell design flow

After routing the chip successfully, let us see the cell design flow. **Cell design flow** is the process of creating and validating a standard cell from transistor-level design to final characterized library cell. The main inputs required for cell design are PDK files, DRC and LVS design rules, SPICE models, technology files, and design specifications. Using these inputs, the designer creates schematic, layout, performs verification, parasitic extraction, and finally characterizes the cell for timing, power, and noise analysis.

## Lec2,3,4 : Circuit design step, Layout design steps and Typical characterization flow

- **User-defined** specifications are design requirements decided before creating a standard cell, such as gate length, cell height, supply voltage, metal layers, pin locations, drive strength, and timing targets. These specifications ensure all cells follow a uniform architecture and are compatible with placement and routing. The ouput getting CDL(circuit description language).
- **The library developer’s responsibility** is to design and optimize the cells according to these specifications, perform DRC/LVS verification, extract parasitics, and characterize timing, power, and noise so the cells can be reliably used in ASIC design flow.The ouput is GDS||, LEF, .cir(extracted spice netlist)
- After defining the specifications, we go through the main **cell design steps** which **include** `circuit/schematic design`(In order to get required current or delay specification), `physical layout design`(Stick diagram using Eular path), and `characterization`. In schematic design, transistor-level functionality is created and verified. Then the layout is designed following DRC/LVS rules, and finally characterization is performed to generate timing, power, and noise models for library usage. The ouput getting timing, noise , poer (.lib), function.


# Section 4 - General timing characterization parameters
## Lec1 : Timing threshold definitions
Timing threshold definitions specify the voltage percentages used to measure signal transition (slew) and delay during characterization. Example terms:

* `slew_lower_rise_thr` → lower voltage point for rising slew measurement (example 20% VDD)
* `slew_upper_rise_thr` → upper voltage point for rising slew measurement (example 80% VDD)
* `slew_lower_fall_thr` → upper voltage point for falling transition start (example 80% VDD)
* `slew_upper_fall_thr` → lower voltage point for falling transition end (example 20% VDD)
* `input_threshold_fall` → voltage point where falling input delay measurement is taken (usually 50% VDD).

## Lec2 : Propagation delay and transition time
* **Propagation Delay:** is the time taken for a change at the input of a gate/cell to appear at the output. Usually measured between 50% input voltage point and 50% output voltage point.Example input crosses 0.9V at 2ns and output crosses 0.9V at 3ns then the propagation delay = 1ns.

* **Transition Time (Slew)** is the time taken for a signal to change from LOW→HIGH or HIGH→LOW. Usually measured rising slew → 20% to 80% VDD, falling slew → 80% to 20% VDD. Smaller transition time means faster switching and better timing performance.

</details>

<details> 
	<summary> DAY 3 -  Design library cell using Magic Layout and ngspice characterization </summary>

# Section 1 - Labs for CMOS inverter ngspice simulations
## Lec0 : IO placer revision

* IO placement is the process of arranging input and output pins around the chip boundary during floorplanning. It helps reduce routing congestion and improves connectivity between external pins and internal logic.
* We changed the floorplan switch `FP_IO_MODE` from `1` to `2` to observe different IO pin arrangements. Initially, the older Docker/OpenLane setup produced errors during floorplanning, so a newer Docker container was pulled and used successfully. After loading the generated DEF file in Magic, we analyzed the floorplan and observed that with `FP_IO_MODE=2`, the IO pins appeared more closely packed and distributed differently around the chip boundary.

 ![image alt](https://github.com/Neha856/SoC_Design/blob/141aa6ba51ac45077d33e8532ef9f658960bf0b9/Presentation10.png)

```bash
cd ~/Desktop/OpenLane
docker pull ghcr.io/the-openroad-project/openlane:latest
docker run --rm -it \
-v /home/vscode/Desktop/OpenLane:/openlane \
-v /home/vscode/.ciel:/home/vscode/.ciel \
-e PDK_ROOT=/home/vscode/.ciel \
-e PDK=sky130A \
-e STD_CELL_LIBRARY=sky130_fd_sc_hd \
-e DISPLAY=:1 \
-v /tmp/.X11-unix:/tmp/.X11-unix \
ghcr.io/the-openroad-project/openlane:latest
```
* We do NOT need `make mount` now. Because we already manually started the Docker container using: "docker run......latest"".

```tcl
./flow.tcl -interactive
package require openlane
prep -design picorv32a
run_synthesis
set ::env(FP_IO_MODE) 2
run_floorplan
```
```bash
cd ~/Desktop/OpenLane/designs/picorv32a/runs/RUN_2026.05.19_09.30.10/results/floorplan
magic -T /home/vscode/.ciel/sky130A/libs.tech/magic/sky130A.tech
```
```tkcon
lef read ../../tmp/merged.nom.lef
def read picorv32a.def
```
![image alt](https://github.com/Neha856/SoC_Design/blob/141aa6ba51ac45077d33e8532ef9f658960bf0b9/Presentation11.png)

## Lec1&2 :  SPICE deck creation for CMOS inverter

- **What is a SPICE Deck?**  A SPICE deck is a text file that describes an electronic circuit for simulation in tools like: ngspice,LTspice. It contains: transistors, resistors, capacitors, voltage sources and simulation commands.
- **Why NMOS and PMOS substrate/body connection is required** We connect NMOS body to GND(VSS) and PMOS body to VDD to prevent -
   - **1.Body effect:** Threshold voltage changes if: VSB ≠ 0.This changes transistor behavior.V
   - **2.Prevents Unwanted Diode Conduction:** Inside MOSFET there are parasitic PN junction diodes. Wrong body connection can forward bias diode cause current           flow which damage logic behavior.
   - **3.Prevents Latch-Up:** In CMOS NMOS and PMOS create parasitic bipolar transistors, improper substrate/well bias may trigger latch-up this can cause huge           current and chip failure.
![image alt](https://github.com/Neha856/SoC_Design/blob/c99b84dea43c5bcdde58f5270e9cc7bbefa6b7f0/Screenshot%202026-05-21%20140057.png)



## Lec3 :  Switching Threshold Vm

**Switching Threshold** is voltage where CMOS inverter switches state. At switching threshold Vin = Vout. Both NMOS and PMOS are ON near this point. Also called trip point, inverter threshold voltage and switching point. For robust CMOS design Vm = Vdd/2.  Switching Threshold is Important for

 - **1. Better Noise Margin:**  It Improves immunity against noise, Prevents wrong logic detection and Gives stable logic HIGH and LOW.
 - **2. Prevents False Switching:** Noise will not easily change logic state that why Circuit becomes more reliable.
 - **3. Balanced Rise and Fall Delay:** Output transitions become symmetric. Improves timing performance.
 - **4. Reduces Short-Circuit Power:** Minimizes simultaneous NMOS and PMOS conduction. Reduces power dissipation.
 - **5. Improves Robustness:** Circuit works reliably under: voltage variation, temperature variation, noise and process variation.


**Switching Threshold is Controlled** Mainly by transistor sizing (W/L) ratio. Practical Fact is that Electron mobility `μn > μp`. NMOS is naturally stronger than PMOS. So PMOS width has to be increased. Generally `Wp ≈ (2–3times) × Wn` which helps shift threshold near mid-supply.

![image alt](https://github.com/Neha856/SoC_Design/blob/483dd3b9b4ca77373e3caf1c2a8973d93fc39f54/Presentation12.png)

## Lec4 :  Static and dynamic simulation of CMOS inverter

* Static behaviour of CMOS inverter is analyzed using Voltage Transfer Characteristics (VTC). It shows the relation between input voltage and output voltage and helps determine switching threshold and noise margin.
* Dynamic behaviour studies how the inverter responds with time during switching. It includes rise time, fall time, propagation delay, and charging/discharging of load capacitance.
* Static analysis focuses on stable logic states, while dynamic analysis focuses on switching speed and transient performance.

## Lec4 :  Lab steps to git clone vsdstdcelldesign

Clone custom inverter standard cell design from github repository: [Standard cell design and characterization using OpenLANE flow](https://github.com/nickson-jose/vsdstdcelldesign).

```bash
# Change directory to openlane
cd ~/Desktop/openlane

# Clone the repository with custom inverter design
git clone https://github.com/nickson-jose/vsdstdcelldesign

# To come back my first docker container
make mount

# Change into repository directory
cd vsdstdcelldesign

# To find directory of sky130A.tech file
find /home/vscode/ .ciel -name "sky130A. tech"

# Copy magic tech file to the repo directory for easy access
 cp /home/vscode/.ciel/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.tech/magic/sky130A.tech .

# Check contents whether everything is present
ls

# Command to open custom inverter layout in magic
magic -T sky130A.tech sky130_inv.mag &
```

# Section 2 - Inception of Layout – CMOS fabrication process
## Lec1to7 : CMOS febrication process

### 16-Mask CMOS Fabrication Process

**1. Selecting Substrate** Fabrication starts with a silicon wafer substrate. Usually a lightly doped P-type substrate is used for CMOS fabrication.  It acts as the base material for building transistors and interconnections.

**2. Creating Active Region (Mask 1)** Active regions are defined using oxidation and lithography. These regions specify where transistors will be formed. Field oxide isolates one device from another.

**3. N-Well and P-Well Formation** N-well is created for PMOS transistors and P-well for NMOS transistors. Ion implantation and diffusion processes are used. Wells help provide proper body connection and isolation.

**4. Formation of Gate and Gate Regions** Thin gate oxide is grown over silicon surface. Polysilicon is deposited and patterned to form gates. Gate controls current flow between source and drain.

**5. Lightly Doped Drain (LDD) Formation** Light doping is introduced near source/drain edges. LDD reduces hot-electron effects and electric field peaks. It improves device reliability and performance.

**6. Source and Drain Formation** Heavy doping is performed to create source and drain terminals. NMOS uses N+ doping and PMOS uses P+ doping. These regions allow current conduction in transistors.

**7. Contact and Interconnect Formation** Contact holes are opened through insulating oxide layers. Metal contacts connect transistors to routing layers. Interconnects enable signal and power connections.

**8. Higher-Level Metal Formation** Multiple metal layers are formed for complex routing. Vias connect different metal layers vertically. Higher metal layers reduce routing congestion and resistance.


![image alt](https://github.com/Neha856/SoC_Design/blob/d9e2652fc81cf62761a51ddb7082dda8bf1884bd/fLvKx6JAIcLEqST69dvGgISS_FgibgkDVNNacmob7CvB3hrqdP2t2d-J5rca-e2NwgUqlEf6CBTj9OnhWaz4L77zN-cJ-GzIQ-cx8-6NF2E8EKSdcBd4V3KzGqQXvHk1OuLJ-IOXST0KjoDZ6Cw2EbGN1AVm_UMTS6BFwyYgXjgBZtatYx71_NAZfvJyCJ0e.jpg)

## Lec8 : Lab introduction to Sky130 basic layers layout and LEF using inverter
Using Vnc_lite.html website we have open custom layout of Cmos inverter in magic And NMOS and PMOS identified.

![image alt](https://github.com/Neha856/SoC_Design/blob/1fbe45e4e0fec992417a0bd3166605037787370e/Screenshot%202026-05-19%20190039.png)
![image alt](https://github.com/Neha856/SoC_Design/blob/1fbe45e4e0fec992417a0bd3166605037787370e/Screenshot%202026-05-19%20191037.png)
Verified the output Y connectivity to PMOS and NMOS drain 
![image alt](https://github.com/Neha856/SoC_Design/blob/1fbe45e4e0fec992417a0bd3166605037787370e/Screenshot%202026-05-19%20191439.png)


## Lec8 : Lab steps to create std cell layout and extract spice netlist

- Deleting necessary layout part to see DRC error
![image alt](https://github.com/Neha856/SoC_Design/blob/1fbe45e4e0fec992417a0bd3166605037787370e/Screenshot%202026-05-19%20192625.png)
- Commands for spice extraction of the custom inverter layout to be used in tkcon window of magic

```tcl
# Check current directory
pwd

# Extraction command to extract to .ext format
extract all

# Before converting ext to spice this command enable the parasitic extraction also
ext2spice cthresh 0 rthresh 0

# Converting to ext to spice
ext2spice
```
![image alt](https://github.com/Neha856/SoC_Design/blob/1fbe45e4e0fec992417a0bd3166605037787370e/Screenshot%202026-05-19%20205750.png)



# Section 3 - Sky130 Tech File Labs 
## Lec1 : Lab steps to create final SPICE deck using Sky130 tech

Screenshot of created spice file
![image alt](https://github.com/Neha856/SoC_Design/blob/4eb714e11e0ddfae290725fd84df8307aed635e6/Screenshot%202026-05-19%20210053.png)

Measuring unit distance in layout grid
![image alt](https://github.com/Neha856/SoC_Design/blob/8bbe0c5c96356d998b145da4e37f0c08e059f505/Screenshot%202026-05-19%20211506.png)

Screenshot of library model name 
![image alt](https://github.com/Neha856/SoC_Design/blob/8bbe0c5c96356d998b145da4e37f0c08e059f505/Screenshot%202026-05-19%20214056.png)

Editing the spice model file for analysis through simulation.
![image alt](https://github.com/Neha856/SoC_Design/blob/8bbe0c5c96356d998b145da4e37f0c08e059f505/Screenshot%202026-05-21%20154546.png)


## Lec2 : Lab steps to characterize inverter using sky130 model files

```bash
# Running ngspice for post layout simulation
ngspice sky130_inv.spice

# plotting input and ouput with respect to time
plot y vs time a
```
![image alt](https://github.com/Neha856/SoC_Design/blob/bbb49b6cf87e88988a77fd35072108e3477574c6/Screenshot%202026-05-20%20142403.png)
![image alt](https://github.com/Neha856/SoC_Design/blob/bbb49b6cf87e88988a77fd35072108e3477574c6/Screenshot%202026-05-20%20143136.png)

**Rise transition time calculation**

```math
Rise\ transition\ time = Time\ taken\ for\ output\ to\ rise\ to\ 80\% - Time\ taken\ for\ output\ to\ rise\ to\ 20\%
```
```math
20\%\ of\ output = 660\ mV
```
```math
80\%\ of\ output = 2.64\ V
```

![image alt](https://github.com/Neha856/SoC_Design/blob/e8fea97ed7041b58bb0668bdbfffdd8291f6cbb6/Presentation13.png)

**Fall transition time calculation**

```math
Fall\ transition\ time = Time\ taken\ for\ output\ to\ fall\ to\ 20\% - Time\ taken\ for\ output\ to\ fall\ to\ 80\%
```
```math
20\%\ of\ output = 660\ mV
```
```math
80\%\ of\ output = 2.64\ V
```
![image alt](https://github.com/Neha856/SoC_Design/blob/e8fea97ed7041b58bb0668bdbfffdd8291f6cbb6/Presentation14.png)

**Rise Cell Delay Calculation**

```math
Rise\ Cell\ Delay = Time\ taken\ for\ output\ to\ rise\ to\ 50\% - Time\ taken\ for\ input\ to\ fall\ to\ 50\%
```
```math
50\%\ of\ 3.3\ V = 1.65\ V
```
![image alt](https://github.com/Neha856/SoC_Design/blob/e8fea97ed7041b58bb0668bdbfffdd8291f6cbb6/Presentation15.png)

**Fall Cell Delay Calculation**

```math
Fall\ Cell\ Delay = Time\ taken\ for\ output\ to\ fall\ to\ 50\% - Time\ taken\ for\ input\ to\ rise\ to\ 50\%
```
```math
50\%\ of\ 3.3\ V = 1.65\ V
```
![image alt](https://github.com/Neha856/SoC_Design/blob/e8fea97ed7041b58bb0668bdbfffdd8291f6cbb6/Presentation16.png)


## Lec3 : Lab introduction to Magic tool options and DRC rules

**SkyWater SKY130 PDK Periphery Rules document:** It contains all the DRC (Design Rule Check) rules used during CMOS layout design in the SkyWater Technology process. It defines important rules such as: minimum width of poly/metal, spacing between layers, diffusion and well rules,contact and via rules. These rules ensure the chip can be manufactured correctly without shorts, leakage, or fabrication defects. Layout tools like Magic VLSI use these rules during DRC checking.

Link to Sky130 Periphery rules: [https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html](https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html)

## Lec4 : Lab introduction to Sky130 pdk's and steps to download labs

Commands to download and view the corrupted skywater process magic tech file and associated files to perform drc corrections

```bash
# Change to home directory
cd

# Command to download the lab files
wget http://opencircuitdesign.com/open_pdks/archive/drc_tests.tgz

# Since lab file is compressed command to extract it
tar xfz drc_tests.tgz

# Change directory into the lab folder
cd drc_tests

# List all files and directories present in the current directory
ls -al

# Command to view .magicrc file
vim .magicrc

# Command to open magic tool in better graphics
magic -d XR &
```
![image alt](https://github.com/Neha856/SoC_Design/blob/80fadbf0eea32040de9507e7b2c55959b30408e9/Screenshot%202026-05-20%20165940.png)


## Lec5 : Lab introduction to Magic and steps to load Sky130 tech-rules

After loading met3.mag file getting 
![image alt](https://github.com/Neha856/SoC_Design/blob/ae65ce30039f3b55b90bdb1632341242dbc1b4e2/Screenshot%202026-05-20%20171654.png)
Checking drc of selected area
![image alt](https://github.com/Neha856/SoC_Design/blob/53bd4035561e54124ad68c5cd6f1c3eeb7117a8c/Screenshot%202026-05-20%20172204.png)

## Lec6 : Lab exercise to fix poly.9 error in Sky130 tech-file

```bash
# loading poly layer in magic layout
load poly
# checking poly layer
what
```
![image alt](https://github.com/Neha856/SoC_Design/blob/887ab6067e59f287b2160ad3fe34d9cd50099e7d/Screenshot%202026-05-20%20173140.png)
![image alt](https://github.com/Neha856/SoC_Design/blob/887ab6067e59f287b2160ad3fe34d9cd50099e7d/Screenshot%202026-05-20%20173243.png)

Screenshot of poly rules
![Screenshot from 2024-03-21 22-54-49](https://github.com/fayizferosh/soc-design-and-planning-nasscom-vsd/assets/63997454/9260cf37-5933-44a1-8362-597183644334)

Incorrectly implemented poly.9 rule no drc violation even though spacing < 0.48u 
![image alt](https://github.com/Neha856/SoC_Design/blob/887ab6067e59f287b2160ad3fe34d9cd50099e7d/Screenshot%202026-05-20%20173508.png)


New commands inserted in sky130A.tech file to update drc(NOTE: One error in screenshot there is no space before uhrpoly)
![image alt](https://github.com/Neha856/SoC_Design/blob/2cd8c5354f43908bb6b17b43063a058323b3d621/Screenshot%202026-05-20%20175451.png)
![image alt](https://github.com/Neha856/SoC_Design/blob/2cd8c5354f43908bb6b17b43063a058323b3d621/Screenshot%202026-05-20%20175842.png)

Commands to run in tkcon window

```tcl
# Loading updated tech file
tech load sky130A.tech

# Must re-run drc check to see updated drc errors
drc check

# Selecting region displaying the new errors and getting the error messages 
drc why
```
![image alt](https://github.com/Neha856/SoC_Design/blob/2cd8c5354f43908bb6b17b43063a058323b3d621/Screenshot%202026-05-20%20215913.png)

## lec7to9 : Lab exercise to implement poly resistor spacing to diff and tap

Making copies of resistor to check diffusion 
![image alt](https://github.com/Neha856/SoC_Design/blob/2cd8c5354f43908bb6b17b43063a058323b3d621/Screenshot%202026-05-20%20230008.png)

**Incorrectly implemented difftap.2 simple rule correction** Screenshot of difftap rules are below
![image alt](https://github.com/Neha856/SoC_Design/blob/2cd8c5354f43908bb6b17b43063a058323b3d621/Screenshot%202026-05-20%20231917.png)

**Incorrectly implemented nwell.4 complex rule correction** Screenshot of nwell rules are below 
![image alt](https://github.com/Neha856/SoC_Design/blob/58743e15a0721813c2d9f6d9048ae178fe0e05e9/Screenshot%202026-05-20%20232016.png)

```bash
load nwell.mag
```
![image alt](https://github.com/Neha856/SoC_Design/blob/58743e15a0721813c2d9f6d9048ae178fe0e05e9/Screenshot%202026-05-20%20235418.png)

Commands to run in tkcon window

```tcl
# Loading updated tech file
tech load sky130A.tech

# Change drc style to drc full
drc style drc(full)

# Must re-run drc check to see updated drc errors
drc check

# Selecting region displaying the new errors and getting the error messages 
drc why
```
![image alt](https://github.com/Neha856/SoC_Design/blob/58743e15a0721813c2d9f6d9048ae178fe0e05e9/Screenshot%202026-05-20%20235905.png)

</details>

<details> 
	<summary> DAY 4 -  Pre-layout timing analysis and importance of good clock tree </summary>


# Section 1 - Timing modelling using delay tables
## Lec1 : Lab steps to convert grid info to track info

Commands to open the custom inverter layout

```bash
# Change directory to vsdstdcelldesign
cd Desktop/OpenLane/vsdstdcelldesign

# Command to open custom inverter layout in magic
magic -T sky130A.tech sky130_inv.mag &
```
Screenshot of tracks.info of sky130_fd_sc_hd
![image alt](https://github.com/Neha856/SoC_Design/blob/d9ebcb1150467047f6619b8e2ea492b99fce8a7a/Screenshot%202026-05-21%20210030.png)
![image alt](https://github.com/Neha856/SoC_Design/blob/d9ebcb1150467047f6619b8e2ea492b99fce8a7a/Screenshot%202026-05-21%20210016.png)


Commands for tkcon window to set grid as tracks of locali layer

```tcl
# Get syntax for grid command
help grid
# Set grid values accordingly
grid 0.46um 0.34um 0.23um 0.17um
```
![image alt](https://github.com/Neha856/SoC_Design/blob/d9ebcb1150467047f6619b8e2ea492b99fce8a7a/Screenshot%202026-05-21%20211117.png)
![image alt](https://github.com/Neha856/SoC_Design/blob/d9ebcb1150467047f6619b8e2ea492b99fce8a7a/Screenshot%202026-05-21%20211318.png)

Condition 1 verified
```math
Horizontal\ track\ pitch = 0.46\ um
```
![image alt](https://github.com/Neha856/SoC_Design/blob/d9ebcb1150467047f6619b8e2ea492b99fce8a7a/Screenshot%202026-05-21%20212112.png)

```math
Width\ of\ standard\ cell = 1.39\ um = 0.46 * 3
```
Condition 2 verified

```math
Vertical\ track\ pitch = 0.34\ um
```
![image alt](https://github.com/Neha856/SoC_Design/blob/d9ebcb1150467047f6619b8e2ea492b99fce8a7a/Screenshot%202026-05-21%20212408.png)

```math
Height\ of\ standard\ cell = 2.70\ um = 0.34 * 8
```

## lec2 : Lab steps to convert magic layout to std cell LEF
Command for tkcon window to save the layout with custom name

```tcl
# Command to save as
save sky130_vsdinv.mag
```

```bash
# Command to open custom inverter layout in magic
magic -T sky130A.tech sky130_vsdinv.mag &
```
![image alt](https://github.com/Neha856/SoC_Design/blob/4c81b0574205a66ed7c3572916f64b44564fd3e3/Screenshot%202026-05-22%20213947.png)

```tcl
# lef command
lef write
```
![image alt](https://github.com/Neha856/SoC_Design/blob/4c81b0574205a66ed7c3572916f64b44564fd3e3/Screenshot%202026-05-22%20214054.png)
![image alt](https://github.com/Neha856/SoC_Design/blob/4c81b0574205a66ed7c3572916f64b44564fd3e3/Screenshot%202026-05-21%20215447.png)


## lec3 : Introduction to timing libs and steps to include new cell in synthesis

Commands to copy necessary files to 'picorv32a' design 'src' directory

```bash
# Copy lef file
cp sky130_vsdinv.lef ~/Desktop/OpenLane/designs/picorv32a/src/

# List and check whether it's copied
ls ~/Desktop/OpenLane/designs/picorv32a/src/

# Copy lib files
cp libs/sky130_fd_sc_hd__* ~/Desktop/OpenLane/designs/picorv32a/src/

# List and check whether it's copied
ls ~/Desktop/OpenLane/designs/picorv32a/src/
```
## lec4to6 : Introduction to delay tables
- **Introduction to Delay Tables**
    - **Definition of delay tables**: Lookup tables in `.lib` files that describe how gate delay changes.  
	- **Two key parameters**:  
            - Input transition time (slew).  
  		    - Output load capacitance.  
	- **2D table format**: Delay values stored for combinations of slew × load.  
	- **Purpose**: Enables accurate timing analysis during synthesis, placement, and CTS.  
	- **Takeaway**: Delay tables are the foundation of static timing analysis.

- **Delay Table Usage (Part 1)**
     - **Reading delay tables**: How to map input slew and output load to a delay value.  
	 - **Interpolation**: Tools interpolate between table entries if exact values aren’t present.  
	 - **Operating conditions**: Voltage, temperature, and process corner affect which table is used.  
	 - **Practical example**: Shows how a buffer’s delay is calculated using table entries.  
	 - **Takeaway**: Understanding how tools pick values helps debug timing reports.

 - **Delay Table Usage (Part 2)**
     - **Applying delay tables in timing**: Demonstrates how STA tools use them in path analysis.  
	 - **Setup and hold checks**: Relies on delay table values for accurate slack calculation.  
	 - **Timing reports**: Delay tables explain why certain paths fail or pass.  
	 - **Debugging violations**: Engineers use delay tables to trace back issues in CTS or routing.  
	 - **Takeaway**: Mastery of delay tables is essential for fixing timing violations.


## lec7 :  Lab steps to configure synthesis settings to fix slack and include vsdinv
Commands to be added to config.tcl to include our custom cell(sky130_vsdinv) in the openlane flow

```tcl
set ::env(LIB_SYNTH) "$::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__typical.lib"
set ::env(LIB_FASTEST) "$::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__fast.lib"
set ::env(LIB_SLOWEST) "$::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__slow.lib"
set ::env(LIB_TYPICAL) "$::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__typical.lib"

set ::env(EXTRA_LEFS) [glob $::env(OPENLANE_ROOT)/designs/$::env(DESIGN_NAME)/src/*.lef]
```

Edited config.tcl to include the added lef and change library to ones we added in src directory
![image alt](https://github.com/Neha856/SoC_Design/blob/2d379650e66743d179e2d1d384a327a3561aba87/Screenshot%202026-05-21%20221347.png)

Commands to invoke the OpenLANE flow include new lef and perform synthesis 

```bash
# Change directory to openlane flow directory
cd Desktop/Openlane
# open docker container
make mount
```
```tcl
# Now that we have entered the OpenLANE flow contained docker sub-system we can invoke the OpenLANE flow in the Interactive mode using the following command
./flow.tcl -interactive

# Now that OpenLANE flow is open we have to input the required packages for proper functionality of the OpenLANE flow
package require openlane 1.0.2

# Now the OpenLANE flow is ready to run any design and initially we have to prep the design creating some necessary files and directories for running a specific design which in our case is 'picorv32a
prep -design picorv32a -tag [new run folder] -overwrite

# Adiitional commands to include newly added lef to openlane flow
set lefs [glob $::env(DESIGN_DIR)/src/*.lef]
add_lefs -src $lefs

# Now that the design is prepped and ready, we can run synthesis using following command
run_synthesis
```
![image alt](https://github.com/Neha856/SoC_Design/blob/a30b57188ded1e16565b869bc026f42e1a4128b9/Screenshot%202026-05-21%20222709.png)

Commands to view and change parameters to improve timing and run synthesis

```tcl
# Now once again we have to prep design so as to update variables
prep -design picorv32a -tag latestrunfolder -overwrite

# Addiitional commands to include newly added lef to openlane flow merged.lef
set lefs [glob $::env(DESIGN_DIR)/src/*.lef]
add_lefs -src $lefs

# Command to display current value of variable SYNTH_STRATEGY
echo $::env(SYNTH_STRATEGY)

# Command to set new value for SYNTH_STRATEGY
set ::env(SYNTH_STRATEGY) "DELAY 3"

# Command to display current value of variable SYNTH_BUFFERING to check whether it's enabled
echo $::env(SYNTH_BUFFERING)

# Command to display current value of variable SYNTH_SIZING
echo $::env(SYNTH_SIZING)

# Command to set new value for SYNTH_SIZING
set ::env(SYNTH_SIZING) 1

# Command to display current value of variable SYNTH_DRIVING_CELL to check whether it's the proper cell or not
echo $::env(SYNTH_DRIVING_CELL)

# Now that the design is prepped and ready, we can run synthesis using following command
run_synthesis
```
![image alt](https://github.com/Neha856/SoC_Design/blob/a30b57188ded1e16565b869bc026f42e1a4128b9/Screenshot%202026-05-21%20233607.png)
![image alt](https://github.com/Neha856/SoC_Design/blob/a30b57188ded1e16565b869bc026f42e1a4128b9/chip_area.png)
![image alt](https://github.com/Neha856/SoC_Design/blob/a30b57188ded1e16565b869bc026f42e1a4128b9/time_slack.png)

Now that our custom inverter is properly accepted in synthesis we can now run floorplan using following command

```tcl
# Now we can run floorplan
run_floorplan
```
![image alt](https://github.com/Neha856/SoC_Design/blob/a30b57188ded1e16565b869bc026f42e1a4128b9/Screenshot%202026-05-21%20235306.png)

Now that floorplan is done we can do placement using following command

```tcl
# Now we are ready to run placement
run_placement
```
![image alt](https://github.com/Neha856/SoC_Design/blob/a30b57188ded1e16565b869bc026f42e1a4128b9/Screenshot%202026-05-22%20001205.png)

load placement def in magic in another terminal
![image alt](https://github.com/Neha856/SoC_Design/blob/a5383364748c8dc796a964af42e0e33175b2ae45/Screenshot%202026-05-22%20001821.png)
![image alt](https://github.com/Neha856/SoC_Design/blob/6c84fed9ba5591035cb008b4b49109f95be7bdc7/Screenshot%202026-05-23%20042329.png)
Command for tkcon window to view internal layers of cells

```tcl
# Command to view internal connectivity layers
expand
```
![image alt](https://github.com/Neha856/SoC_Design/blob/6c84fed9ba5591035cb008b4b49109f95be7bdc7/Screenshot%202026-05-23%20042353.png)


# Section 2 - Timing analysis with ideal clocks using openSTA
## Lec1&2 : Setup timing analysis and introduction to flip-flop setup time, Introduction to clock jitter and uncertainty

System-on-chip (SoC) design has become a cornerstone of modern electronic systems. Ensuring the chip functions correctly at the intended speed is a crucial aspect of chip design. This is where static timing analysis (STA) comes into play. STA is a method used to determine if a design meets timing constraints, ensuring that signals are propagated and synchronized correctly throughout the entire chip. The word static in STA means that the timing analysis does not depend upon the data values being applied at the input pins.

Static timing analysis aims to ensure that a given design, with the specified input clock definitions and the external environment parameters, can function at the intended speed without any timing issues. Unlike dynamic simulation, which tests specific input vectors and scenarios, STA analyzes the circuit by considering all possible paths and combinations of delays. The most important aspect of static timing analysis is that the entire design is analyzed once, and the required timing checks are performed for all possible paths and scenarios. Thus, STA is a complete and exhaustive method for verifying a design's timing.

### Benefits of STA 

Static timing analysis (STA) plays a crucial role in VLSI design, ensuring the timing correctness of a design. By analyzing the timing behavior under various conditions, STA helps engineers optimize their designs, achieve timing closure, and verify system functionality. It offers many benefits, such as:

- **Timing Closure:** STA is crucial for achieving timing closure in designs. STA identifies critical paths and timing violations, helping designers refine circuits to meet timing constraints.

- **Performance Optimization:** STA is crucial for optimizing the performance of VLSI designs. It identifies and analyzes the critical timing paths, allowing engineers to pinpoint and enhance areas that significantly impact the design's performance. The insights provided by STA enable informed decisions to boost the design's speed, power efficiency, and overall effectiveness.

- **Verification and Validation:** STA is a crucial tool for validating VLSI designs. It simulates circuit behavior, considering process changes, environmental factors, and extreme conditions to detect timing errors. This process aids in uncovering design flaws, if any.

- **Enhanced Design Quality and Reduced Cost:** STA integrates design rule checks (DRCs) to ensure designs meet specific manufacturing standards, improving yield, reducing costs, and enhancing quality. Early identification of issues through timing data leads to more reliable and robust designs.

- **Large-Scale Design Signoff:** Distributed STA is a robust and mature methodology that enables the distribution of a single timing graphic across multiple machines, essential for signing off designs with over a billion instances. This innovative approach accelerates the STA process by enhancing compute resource efficiency and improving signoff accuracy.


#### Input Files

- `*.v`  : Gate-level Verilog Netlist  
- `*.lib` : Liberty Timing Libraries  
- `*.sdc` : Synopsys Design Constraints (clocks, delays, false paths)  
- `*.sdf` : Annotated Delay File (optional)  
- `*.spef`: Parasitics (RC extraction)  
- `*.vcd` / `*.saif` : Switching Activity for Power Analysis 

#### Clock Modeling Features

- `Generated Clocks`: Derived from existing clocks  
- `Latency`: Clock propagation delay  
- `Source Latency`: Insertion delay from clock source to input  
- `Uncertainty`: Jitter or skew margins  
- `Propagated vs. Ideal`: Real vs. ideal clock network modeling  
- `Gated Clock Checks`: Verifies clocks that are enabled conditionally  
- `Multi-Frequency Clocks`: Analyzes multiple domains  

#### Exception Paths

Timing exceptions refine analysis for real behavior:

- `set_false_path` — Ignores invalid functional paths  
- `set_multicycle_path` — Allows multiple clock cycles  
- `set_max_delay` / `set_min_delay` — Custom timing limits

#### Timing Paths 

`What do you mean by Timing Paths?`
In digital circuit design, especially during timing analysis (Static Timing Analysis or STA), a timing path represents the route that a signal takes from one point in a circuit to another, typically from one flip-flop to another, from an input to an output, or from input to a flip-flop, etc. It shows how a signal propagates through combinational logic and sequential elements within a clock cycle.

#### Timing Path Elements

**Start Point**: Is the point where the signal originates or enters the digital circuit. This point is typically an input port of the design, where the signal is first introduced to the circuit. The start point of a timing path can be either:

- An input port, where data enters the design, or
- The flop clk pin, where data is launched on a clock edge.

**End Point:** Is the point where the signal terminates or leaves the digital circuit. This point is typically an output port of the design, where the signal is outputted from the circuit. The end point of a timing path can be either:

- A register's data input pin (D pin), where data is captured by the clock edge, or
- An output port, where data must be available at a specific time.

**Combinational Logic:** Combinational logic elements are the building blocks of a digital circuit and are used to perform logic operations on the signals passing through the circuit. These elements do not store any information, and the output of a combinational logic element is solely determined by the input values at that moment.

**Types of timing paths**

- **Register-to-Register Path**
Flip-flop → Combinational logic → Flip-flop
(Most common type in synchronous design)

- **Input-to-Register Path**
Input port → Combinational logic → Flip-flop

- **Register-to-Output Path**
Flip-flop → Combinational logic → Output port

- **Input-to-Output Path**
Input port → Combinational logic → Output port

- **Clk gating** 
Clock gating is a power-saving technique where the clock signal is disabled for certain parts of a circuit when not in use. It reduces dynamic power consumption by stopping unnecessary switching activity.

- **Recovery and removal time**
*Recovery time* is the minimum time the asynchronous control signal (like reset) must be de-asserted before the next active clock edge.
*Removal time* is the minimum time the asynchronous signal must remain inactive after a clock edge to ensure correct operation.

- **Data-to-data path**
A data-to-data path measures the timing relationship between two independent data signals.
It is often used to check timing between asynchronous interfaces or combinational logic outputs.

- **Latch Timing(time borrow and time given)**
**Time borrowing** allows a latch to use extra time from the next clock phase to meet setup timing.
**Time given** means a latch provides unused time from its phase to the next stage, helping balance timing across pipeline stages.

#### Setup and Hold Checks

-> **What is Setup Check?**
* Is the minimum time that the data must be stable before the clock edge, and if this time is not met, it can lead to setup violations, resulting in incorrect data being stored in the sequential element. The setup check is essential to ensure correct timing behavior of a digital circuit and prevent data loss or other timing-related issues.
* The setup time of a flip-flop depends on the technology node, operating conditions, and other factors. The value of the setup time is usually provided in the logic libraries.

-> **What is Hold Check?**
* Is the minimum amount of time that the data must remain stable after the clock edge, and if this time is not met, it can lead to hold violations, resulting in incorrect data being stored in the sequential element. The hold check is necessary to prevent issues such as data corruption, metastability, and other timing-related problems in digital circuits.

#### Slack Calculation 

Setup and hold slack is defined as the difference between data required time and data arrivals time. 

>Setup slack = Data required time - Data arrival time
>Hold slack = Data arrival time - Data required time

-> **What is Data Arrival Time?**
* The time taken by the signal to travel from the start point to the end point of the digital circuit. 

-> **What is Data Required Time?** 
* The time for the clock to traverse through the clock path of the digital circuit. 

-> **What is Slack?** 
* It is difference between the desired arrival times and the actual arrival time for a signal. 
* Positive Slack indicates that the design is meeting the timing and still it can be improved. 
* Zero slack means that the design is critically working at the desired frequency. 
* Negative slack means, design has not achieved the specified timings at the specified frequency.
* Slack has to be positive always and negative slack indicates a violation in timing.

#### Different Types of Analysis in STA

**1.SLEW/TRANSITION ANALYSIS:**
Slew is the rate of change of a signal’s voltage — how quickly it rises or falls between logic levels.
It affects timing accuracy, noise, and power consumption in digital circuits. and Transition analysis checks whether signal transitions (rise/fall times) stay within allowed limits. It ensures signals switch fast enough for reliable operation without delay or distortion. It has 2 categories:
- **Data slew/transition** Data slew refers to the rise or fall time of data signals propagating through combinational paths. Poor data slew can increase delay and degrade timing at the receiving gate.
- **Clock slew/clock transition** Clock slew measures how fast the clock edge changes from low to high or high to low. Accurate clock slew is critical to prevent setup/hold violations and maintain synchronization.

**2.LOAD ANALYSIS:**
Load analysis examines the total capacitive load driven by a cell’s output pin in a circuit.It helps determine how much delay and power the driving cell experiences due to connected gates or wires. Higher load increases signal delay and can degrade transition (slew) performance. Design tools use load analysis to optimize buffering and ensure timing and power meet specifications. Has 2 categories:
- **Fanout Analysis(max and min):** Fanout refers to the number of gates or inputs driven by a single output.
Higher fanout increases the load, leading to slower signal transitions and higher delay.
- **Capacitances Analysis(max and min):** Capacitance is the total electrical load (from wires and input pins) that a driving gate must charge or discharge.It directly affects delay, power consumption, and signal integrity in a circuit.

**3.CLOCK ANALYSIS:**
Clock analysis evaluates the timing quality and integrity of the clock network in a digital circuit.
It ensures the clock reaches all sequential elements reliably with correct timing for proper synchronization. having 2 types:
- **Skew Analysis** Clock skew is the difference in arrival times of the same clock edge at different flip-flops.
Excessive skew can cause setup or hold timing violations, affecting circuit performance.
- **Pulse width Analysis** Pulse width analysis checks that the high and low durations of the clock signal meet minimum required limits. If the pulse width is too short due some parasitic set in the clk network, flip-flops or latches may fail to capture data correctly.

#### *Positive edge triggered FF using Master slave configuration:*
connect negative latch o/p to i/p of positive latch.
![image alt](https://github.com/Neha856/SoC_Design/blob/4f331a1d5512f5fed6b92d58f4d143deb224fd84/Copilot_20260523_032001.png)

#### *JITTER ANAYSIS:*
Jitter analysis measures the timing variation of a clock signal’s edges from their ideal positions over time.
It helps ensure the clock remains stable so data is launched and captured correctly across all flip-flops.
    - Jitter is caused by noise, power supply fluctuations, or clock distribution imperfections.
    - It is usually expressed in picoseconds (ps) as peak-to-peak or RMS jitter.

#### **OCV (On-chip-variation):**
On-Chip Variation refers to timing differences that occur within the same chip due to process, voltage, or temperature fluctuations. Even though two cells are on the same die, they may have slightly different delays because of manufacturing and environmental non-uniformities. like due to,

**1.Etching process:** OCV from etching arises due to microloading and aspect ratio effects, causing gate length and CD variation.

**2.Oxide thickness:** Oxide thickness variation shifts threshold voltage and drive current, impacting delay and leakage. Both processes introduce spatial and systematic mismatches across the die. These variations affect timing, power, and reliability in advanced nodes.

#### **OCV Based setup timing Analysis**
In OCV-based setup analysis, extra margins (derating factors) are applied to timing paths to account for these variations.

-Data path delays are increased (slowed down) — assuming worst-case slower transistors.

-Clock path delays are decreased (sped up) — assuming best-case faster transistors.

This worst-case combination ensures that setup violations are caught even when parts of the chip behave differently. For example,
If nominal delay = 100 ps,

-Data derate = +10% → 110 ps

-Clock derate = −10% → 90 ps
The analysis ensures timing holds even if one region is slower and another is faster.It models early/late arrival times using statistical or bounded variation to catch worst-case delays. **Pessimism removal** identifies paths where both launch and capture flops share variation, reducing overestimated timing margins. This improves timing closure by eliminating unnecessary guardbands while preserving accuracy.



## Lec3 :Lab steps to configure OpenSTA for post-synth timing analysis
Similarly running OpenSTA and newly file created `pre_sta.conf` for STA analysis in `openlane` directory
![image alt](https://github.com/Neha856/SoC_Design/blob/729c5debf340022ed71acea878798e41d7b67734/Screenshot%202026-05-23%20043049.png)
Newly created `my_base.sdc` for STA analysis in `OpenLane/designs/picorv32a/src` directory based on the file `OpenLane/scripts/base.sdc`
![image alt](https://github.com/Neha856/SoC_Design/blob/36990393ec17c58429f1d0e41e3474c3d76707f1/Screenshot%202026-05-23%20043320.png)


Commands to run STA in another terminal

```bash
# Change directory to openlane
cd Desktop/OpenLane
# Command to invoke OpenSTA tool with script
sta pre_sta.conf
```
![image alt](https://github.com/Neha856/SoC_Design/blob/0d0955ffa09a5f2dd400d85e01b0cee16400224d/Screenshot%202026-05-23%20043857.png)

## Lec4 :Lab steps to optimize synthesis to reduce setup violations
Since more fanout is causing more delay we can add parameter to reduce fanout and do synthesis again

Commands to include new lef and perform synthesis 

```tcl
# Now the OpenLANE flow is ready to run any design and initially we have to prep the design creating some necessary files and directories for running a specific design which in our case is 'picorv32a'
prep -design picorv32a -tag latestrunname -overwrite

# Adiitional commands to include newly added lef to openlane flow
set lefs [glob $::env(DESIGN_DIR)/src/*.lef]
add_lefs -src $lefs

# Command to set new value for SYNTH_SIZING
set ::env(SYNTH_SIZING) 1

# Command to set new value for SYNTH_MAX_FANOUT
set ::env(SYNTH_MAX_FANOUT) 4

# Command to display current value of variable SYNTH_DRIVING_CELL to check whether it's the proper cell or not
echo $::env(SYNTH_DRIVING_CELL)

# Now that the design is prepped and ready, we can run synthesis using following command
run_synthesis
```

Commands to run STA in another terminal

```bash
# Change directory to openlane
cd Desktop/work/tools/openlane_working_dir/openlane

# Command to invoke OpenSTA tool with script
sta pre_sta.conf
```
![image alt](https://github.com/Neha856/SoC_Design/blob/a1effb8255f79597def93e084bdd90595661ee32/Screenshot%202026-05-23%20044708.png)

## Lec5 : Lab steps to do basic timing ECO
Command to run OpenROAD tool

```tcl
openroad

# Reading lef file
 read_lef /OpenLane/designs/picorv32a/runs/24-03_10-03/tmp/merged.nom.lef
# Reading def file
 read_def /OpenLane/designs/picorv32a/runs/24-03_10-03/results/cts/picorv32a.def
# Creating an OpenROAD database to work with
 write_db pico_cts.db
# Loading the created database in OpenROAD
 read_db pico_cts.db
# Read netlist post CTS
 read_verilog /OpenLane/designs/picorv32a/runs/24-03_10-03/results/synthesis/picorv32a.v
# Read library for design
 read_liberty $::env(LIB_SYNTH_COMPLETE)
# Link design and library
 link_design picorv32a
# Read in the custom sdc we created
 read_sdc /OpenLane/designs/picorv32a/src/my_base.sdc
# Setting all cloks as propagated clocks
 set_propagated_clock [all_clocks]
# Check syntax of 'report_checks' command
 help report_checks
# Generating custom timing report
report_checks -path_delay min_max -fields {slew trans net cap input_pins} -format full_clock_expanded -digits 4
```
![image alt](https://github.com/Neha856/SoC_Design/blob/b83894eac623a2ef72951e822549282bd6c83ca6/Screenshot%202026-05-23%20045722.png)

</details>

<details> 
	<summary> DAY 5 -  Final steps for RTL2GDS using tritonRoute and openSTA </summary>

# Section 1 - Routing and design rule check (DRC)
## Lec1to3 : Introduction to Maze Routing – Lee’s algorithm,  Lee’s Algorithm conclusion and DRC
**Maze Routing – Introduction:**

- Maze routing is a **path‑finding algorithm** used to connect two points (source and target) in a chip layout.  
- It works on a **grid representation** of the routing area.  
- Each grid cell can be **free**, **occupied**, or **blocked** by obstacles.  
- The goal is to find a **shortest valid path** that avoids obstacles and meets design rules.  
- Used in **global and detailed routing** stages of VLSI design.


**Lee’s Algorithm – Working Principle:**

- Developed by **C.Y. Lee (1961)** — a **breadth‑first search (BFS)** based routing algorithm.  
- Works in **two phases**:
  1. **Expansion phase**:  
     - Starts from the source node.  
     - Propagates a wavefront through neighboring cells, marking each with incremental distance values.  
     - Continues until the target node is reached.
  2. **Backtracking phase**:  
     - Traces back from the target to the source following decreasing distance values.  
     - Produces the **shortest path**.
- Guarantees an **optimal path** if one exists.  
- Simple and robust, but computationally expensive for large grids.


**Lee’s Algorithm – Conclusion:** Provides **complete and optimal routing** always finds a path if one exists. **Limitations**: High memory and time complexity and Not suitable for very large or dense designs. **Improvements**Algorithms like **Hadlock’s**, **A\***, and **Dijkstra’s** are faster alternatives.Still used as a **benchmark** for correctness in routing tools.

**Design Rule Check (DRC)** DRC ensures the **layout obeys manufacturing constraints** defined by the foundry. Checks include **Minimum width** of metal lines, **Minimum spacing** between wires, **Via enclosure**, **overlap**, and **antenna rules**. Performed using tools like **Magic**, **Calibre**, or **KLayout**.  A layout passes DRC only when **no violations** are found — essential before tape‑out.


# Section 2 - Power Distribution Network and routing
## Lec1to7 :  Lab steps to build power distribution network, Lab steps from power straps to std cell power and Basics of global and detail routing and configure TritonRoute

Commands to perform all necessary stages up until now

```bash
# Change directory to openlane flow directory
cd Desktop/OpenLane
make mount
```
```tcl
# Now that we have entered the OpenLANE flow contained docker sub-system we can invoke the OpenLANE flow in the Interactive mode using the following command
./flow.tcl -interactive
# Now that OpenLANE flow is open we have to input the required packages for proper functionality of the OpenLANE flow
package require openlane 0.9
# Now the OpenLANE flow is ready to run any design and initially we have to prep the design creating some necessary files and directories for running a specific design which in our case is 'picorv32a'
prep -design picorv32a
# Addiitional commands to include newly added lef to openlane flow merged.lef
set lefs [glob $::env(DESIGN_DIR)/src/*.lef]
add_lefs -src $lefs
# Command to set new value for SYNTH_STRATEGY
set ::env(SYNTH_STRATEGY) "DELAY 3"
# Command to set new value for SYNTH_SIZING
set ::env(SYNTH_SIZING) 1
# Now that the design is prepped and ready, we can run synthesis using following command
run_synthesis
# Now we are ready to run placement
run_placement
# Incase getting error
unset ::env(LIB_CTS)
# With placement done we are now ready to run CTS
run_cts
# Now that CTS is done we can do power distribution network
gen_pdn 
```
![image alt](https://github.com/Neha856/SoC_Design/blob/167c5d2eee4ee8dd7626c87a0c569a06e10f8634/Screenshot%202026-05-23%20051238.png)
After loading PDN def in magic 
![image alt](https://github.com/Neha856/SoC_Design/blob/167c5d2eee4ee8dd7626c87a0c569a06e10f8634/Screenshot%202026-05-23%20051337.png)
![image alt](https://github.com/Neha856/SoC_Design/blob/167c5d2eee4ee8dd7626c87a0c569a06e10f8634/Screenshot%202026-05-23%20051406.png)



# section3 - TritonRoute Features
## L1to3 : Honors pre-processed route guides, Inter-guide connectivity and intra- & inter-layer routing and TritonRoute method to handle connectivity
Command to perform routing

```tcl
# Check value of 'CURRENT_DEF'
echo $::env(CURRENT_DEF)

# Check value of 'ROUTING_STRATEGY'
echo $::env(ROUTING_STRATEGY)

# Command for detailed route using TritonRoute
run_routing
```
![image alt](https://github.com/Neha856/SoC_Design/blob/527590344fa8f1395dd0e0377e975ee3da65f0e1/Screenshot%202026-05-23%20052859.png)


 ## L4 : Routing topology algorithm and final files list post-route

Commands to be run in OpenLANE flow to do OpenROAD timing analysis with integrated OpenSTA in OpenROAD

```tcl
# Command to run OpenROAD tool
openroad
# Reading lef file
read_lef /openLANE_flow/designs/picorv32a/runs/26-03_08-45/tmp/merged.lef
# Reading def file
read_def /openLANE_flow/designs/picorv32a/runs/26-03_08-45/results/routing/picorv32a.def
# Creating an OpenROAD database to work with
write_db pico_route.db
# Loading the created database in OpenROAD
read_db pico_route.db
# Read netlist post CTS
read_verilog /openLANE_flow/designs/picorv32a/runs/run name/results/synthesis/picorv32a.synthesis_preroute.v
# Read library for design
read_liberty $::env(LIB_SYNTH_COMPLETE)
# Link design and library
link_design picorv32a
# Read in the custom sdc we created
read_sdc /openLANE_flow/designs/picorv32a/src/my_base.sdc
# Setting all cloks as propagated clocks
set_propagated_clock [all_clocks]
# Read SPEF
read_spef /openLANE_flow/designs/picorv32a/runs/26-03_08-45/results/routing/picorv32a.spef
# Generating custom timing report
report_checks -path_delay min_max -fields {slew trans net cap input_pins} -format full_clock_expanded -digits 4
# Exit to OpenLANE flow
exit
```
![image alt](https://github.com/Neha856/SoC_Design/blob/f42c3f31e1843533b6d88c4f627158ae9f61e894/Screenshot%202026-05-15%20090114.png)

</details>

<details> 
	<summary> MY LEARNING </summary>

Completing the [SoC Design and Planning Workshop by VSD and NASSCOM] helped me understand the complete ASIC physical design flow from RTL to GDSII. I learned how to work with the open-source EDA tool flow using [OpenLANE](https://github.com/vsdip/vsd-openlane) and the Google Sky130 PDK. The workshop improved my knowledge of floorplanning, placement, clock tree synthesis, routing, and physical verification. I gained hands-on experience in Linux commands, Verilog design integration, timing analysis, and DRC/LVS checks. I also understood the importance of standard cells, power planning, and optimization techniques in chip design. Through labs, I learned how to debug design issues and analyze reports generated during the ASIC flow. Overall, the workshop strengthened my understanding of VLSI backend design and gave me exposure to real-world SoC implementation methodologies.

</details>

<details> 
	<summary> Tools & Environment </summary>

| Tool | Purpose |
|---|---|
| **OpenLANE** | RTL-to-GDSII automation flow |
| **Yosys** | RTL synthesis |
| **OpenROAD** | Floorplan, Placement, CTS, Routing |
| **Magic** | Layout editor, DRC, LVS |
| **OpenSTA** | Static Timing Analysis |
| **ngspice** | SPICE simulation |
| **TritonRoute** | Detailed routing |
| **Netgen** | LVS (Layout vs Schematic) |
| **Sky130 PDK** | SkyWater 130nm open-source PDK |

</details>

<details> 
	<summary> Acknowledgements </summary>

* [Kunal Ghosh](https://github.com/kunalg123), Co-founder, VSD Corp. Pvt. Ltd.
* [Nickson P Jose](https://github.com/nickson-jose), Physical Design Engineer, Intel Corporation.
* [R. Timothy Edwards](https://github.com/RTimothyEdwards), Senior Vice President of Analog and Design, efabless Corporation.


</details>



























  






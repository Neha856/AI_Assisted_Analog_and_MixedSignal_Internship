# Analog and Mixed signal SoC physical design

<details>

<summary>WEEK 1 - Making IEEE 1-page two column report for TASK 1  </summary>


# Section 1 - Understanding given github repo using Chatgpt, Copilot and Codex
## Learning 1 : Giving AI prompt and following its instruction
### What is the overview of the given github repo  

This repository demonstrates a complete mixed-signal physical design flow by integrating an analog 2:1 multiplexer macro into a digital implementation flow using open-source EDA tools. It includes transistor-level Verilog models, custom analog layout, LEF/LIB generation, DRC verification, and OpenLane-based RTL-to-GDSII implementation. The project provides practical insight into how analog IP blocks are abstracted and incorporated into a digital SoC design flow.

The original repository can be found [here](https://github.com/praharshapm/vsdmixedsignalflow).

### What is Analog and Mixed Signal SoC

An **Analog and Mixed-Signal System-on-Chip (SoC)** integrates both analog and digital circuits on a single chip. Analog blocks process continuous signals, while digital blocks perform computation and control. Typical analog IPs include ADCs, DACs, PLLs, sensors, and analog multiplexers. Mixed-signal SoCs are widely used in communication, automotive, IoT, and consumer electronics.

### What is Foundry, IPs, Foundry IPs and Macros

- **Foundry**: A foundry is the company that manufactures semiconductor chips from the design files. like TSMC, Samsung Electronics, and GlobalFoundries.
- **IP (Intellectual Property)**: IPs are pre-designed reusable circuit blocks used in SoC design instead of designing everything from scratch. Examples: UART, SPI, USB, DDR controller, PLL, CPU core.
- **Foundry IPs**: These are IP blocks provided or qualified by the foundry for a specific technology node.It has a intelligent technique. Common examples are: Standard cells, SRAM, I/O cells, PLL, ESD cells.
- **Macros**: Macros are large pre-designed physical blocks used during floorplanning and layout. They usually have fixed size and placement constraints and it is a pure digital logic. Examples: SRAM macro, ROM macro, Analog blocks, PLL macro.

![image alt](https://github.com/Neha856/SoC_Design/blob/00ca96ded73767c8a2cff0b590671167f70150f8/Screenshot%202026-05-15%20090952.png)

### What is RTL2GDS flow of mixed signal SoC

The RTL-to-GDSII flow converts a digital RTL design into a manufacturable chip layout while integrating pre-designed analog macros. The process includes synthesis, floorplanning, placement, clock tree synthesis, routing, timing verification, and GDSII generation. Analog IPs are incorporated using LEF, LIB, and Verilog abstract views to enable seamless digital implementation.
![image alt](https://github.com/Neha856/SoC_Design/blob/e103318e668825ed5329ff25b3f162d11c2ff586/Screenshot%202026-05-16%20123414.png)


## Learning 2 : OpenROAD Tool Installation 
### What is OpenROAD Project

The OpenROAD Project is an open-source initiative focused on developing a complete, autonomous RTL-to-GDSII ASIC design flow. It integrates multiple open-source tools to enable end-to-end chip implementation without proprietary software. The project supports industry-standard technologies such as the SKY130 PDK and promotes accessible research and education in VLSI physical design.

The  repository can be found [here](https://github.com/The-OpenROAD-Project).

### What is OpenROAD EDA Tools

OpenROAD is an open-source Electronic Design Automation (EDA) tool that automates the digital physical design process. It performs synthesis, floorplanning, placement, clock tree synthesis, routing, timing analysis, and design verification. OpenROAD aims to provide a fully autonomous RTL-to-GDSII implementation flow for ASIC design using open-source technologies.

Detailed installation steps can be found [here](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/ea7c85247df4d6d6fd80db4feb298a1a0e381494/docs/Steps%20to%20install%20OpenROAD%20tools-1.pdf).

Opened 6_final.gds to verify that OpenROAD and KLayout were installed correctly, The GDS viewer was working, The technology/layer mapping was correct. This was only a sample/demo GDS file provided with the OpenROAD/OpenLane examples.

![image alt](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/main/images/6_final_gds.png)

### Clonning the repository as AI suggested 

```bash
# making folder where i want to clone
mkdir vsd_projects
# clonning the reference repo
git clone https://github.com/praharshapm/vsdmixedsignalflow.git
# View the Directory Structure
tree -L 2
```
Directory Structure i get (excluding the `images` folder)

```text
vsdmixedsignalflow/
├── IP Layout/
│   ├── 21muxlayout.mag
│   ├── AMUX2_3V.mag
│   └── AMUX2_3V_test.mag
├── LEF/
│   ├── AMUX2_3V.lef
│   └── txt
├── LIB/
│   ├── AMUX2_3V.lib
│   └── sky130_fd_sc_hd__tt_025C_1v80.lib
├── openlane/
│   ├── config.tcl
│   ├── LEF/
│   ├── results/
│   ├── runs/
│   ├── script.tcl
│   └── verilog/
├── Verilog/
│   ├── AMUX2_3V.v
│   ├── design_mux.v
│   ├── raven_spi.v
│   └── spi_slave.v
├── _config.yml
├── LICENSE
├── README.md
├── sky130A.tech
├── Steps to install OpenROAD tools.pdf
└── verilog_to_lib.pl
```

**Error** i have find during use of openlane and docker is 
    - The repo `vsdmixedsignalflow` is not a full PDK installation.
	- It only has the tech file (sky130A.tech), plus some libraries (LIB, LEF) and design configs.
    - OpenLane’s flow expects a complete Sky130A PDK tree (with libs.ref, libs.tech, etc.), not just a .tech file.
**Rectify** i have installed the full Sky130A PDK and then running mux design.
```bash
# Go to /openlane ,This is where we’ll keep the open_pdks source.
cd /openlane
# Clone the open_pdks
git clone https://github.com/RTimothyEdwards/open_pdks.git
cd open_pdks
# Configure for Sky130A
./configure --enable-sky130-pdk
# Build the PDK
make
# Install the PDK
make install
# Now go to your repo root
cd /vsd_projects/vsdmixedsignalflow
# Set variables
export PDK_ROOT=/usr/local/share/pdk
export PDK=sky130A
export PDK_VARIANT=sky130_fd_sc_hd
# Switch back to the OpenLane tool directory
cd /openlane
flow.tcl -design /vsd_projects/vsdmixedsignalflow/openlane
# Inside container
ls /vsd_projects/vsdmixedsignalflow/openlane/runs/*/results/final/gds
klayout ~/vsd_projects/vsdmixedsignalflow/openlane/runs/<timestamp>/results/final/gds/design_mux.gds &
```

IEEE 1-page two column report can be found [here](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/main/docs/Week1_AI_Assisted_Mixed_Signal_Physical_Design_Flow.pdf).



# Section 2 - Get familiar to open-source EDA tools
## Learning  : OpenLANE Directory structure 
### OpenLane Directory Structure

OpenLane has folders for:

* `designs/` → user chip designs like picorv32a
* `scripts/` → automation scripts
* `runs/` → output files after synthesis, floorplan, placement, routing
* `pdks/` or `.ciel/` → technology files and standard cell libraries.

### PDK (Process Design Kit)

PDK is a collection of files provided by foundry to manufacture chips. It contains technology rules, transistor models, standard cells, LEF/GDS files, timing data, etc. Without PDK, tools do not know how to build the chip physically. They have three pdk folder

- **skywatar-pdk:**  SkyWater is the foundry/company. SkyWater PDK is the open-source 130nm manufacturing technology released by Google + SkyWater.
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




</details>

<details> 
	<summary> WEEK 2 - Analog Macro Design and Verification for TASK 2 </summary>

# Section 1 - Analog macro understanding  
## Learning 1 : What is Analog Macro
### Analog Macro 

An **Analog Macro** or **Analog Intellectual Property (IP)** is a pre-designed and verified analog circuit that can be reused in larger integrated circuits. Unlike digital logic synthesized from RTL, analog macros are manually designed and laid out to meet strict electrical specifications. They are integrated into a digital SoC using abstract views such as **LEF**, **LIB**, and **Verilog**.

### Analog Macro Used in This Repository

The mixed-signal flow uses a **2:1 Analog Multiplexer (AMUX2_3V)** as the analog macro. This macro was originally developed in a separate repository and later integrated into the OpenLane digital implementation flow.

### Clone the Analog Macro Repository

```bash
git clone https://github.com/prithivjp/avsdmux2x1_3v3.git
cd avsdmux2x1_3v3
```
### Installing ngspice

The pre-layout and post-layout simulations were performed using **ngspice**.

```bash
cd ~/Downloads
wget https://sourceforge.net/projects/ngspice/files/ng-spice-rework/46/ngspice-46.tar.gz
tar -xzf ngspice-46.tar.gz
cd ngspice-46
./configure --with-x
make -j$(nproc)
sudo make install
# verify installation
ngspice -v
```
### Repository Structure

```text
avsdmux2x1_3v3/
├── Layout/
    ├── 21muxlayout.mag
    └── 21muxlayout.png 
├── NETLIST/
    ├── 21muxprelayout.cir
    ├── 21muxpostlayout.spice
    ├── NMOS-180nm.lib
    ├── PMOS-180nm.lib
    └── osulib.lib
├── Characteristics/
├── MAGIC/
    ├── SCN6M_SUBM.10.tech
    └── magic.sh 
└── README.md
```
#### Analyze NETLIST/21muxprelayout.cir
- After seeing SPICE netlist `vim NETLIST/21muxprelayout.cir`, **avsdmux2x1_3v3** is a 2 input analog multiplexer. The entire design is done with the help of OSU 180nm library. Transmission gates were used to design the analog multiplexer. The height, width and area of avsdmux2x1_3v3 is given below.
![image alt](https://github.com/prithivjp/avsdmux2x1_3v3/blob/0da4ed47acf7e4da54a5c97980833b1ee9da9bf1)
![image alt](https://github.com/prithivjp/avsdmux2x1_3v3/raw/master/Step_Images/sym21.PNG)
- Their are 6 MOSFETs (M1,M2,M3,M4,M5,M6).M1 and M3 → Transmission Gate for I0,M2 and M4 → Transmission Gate for I1 and M5 and M6 → Inverter. When select=0, N001=1(because N001=!select) then M1 and M3 gets ON and I0 passess at the output.
```text
M1 I0 N001 out vee n_mos l=0.18u w=0.36u
M3 out select I0 vdd p_mos l=0.18u w=0.9u
M2 I1 select out vee n_mos
M4 out N001 I1 vdd p_mos
M5 vdd select N001 vdd p_mos
M6 N001 select vee vee n_mos
```
- This design uses **Transmission gates**, not a logic inverter.The goal is: Low ON resistance (RON), Pass both logic '0' and logic '1' efficiently and Minimize signal attenuation.To compensate for the lower hole mobility in PMOS, the PMOS is made wider. This ratio is based primarily on carrier mobility, so that the NMOS and PMOS contribute similar conductance when the transmission gate is ON. NMOS : 0.36 µm, PMOS : 0.90 µm and Ratio ≈ 2.5.
-  The 5 Voltage source is used which can be shown in below Figure. Example V6 SINE(0 1 25000000) which means the V6 is a sinewave with Offset = 0, VAmplitude = 1 V and Frequency = 25 MHz.

![image alt](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/1e01c10aec823279a80650179a09cd86623e9469/images/2to1_mux.drawio(1).png)
             **Fig - Schematic design based on `NETLIST/21muxprelayout.cir` description.**

#### Pre-Layout Simulation

Run the transistor-level schematic simulation.

```bash
ngspice NETLIST/21muxprelayout.cir
```
**Error** is that the netlist uses uppercase node names (I0, I1, OUT, SELECT), but ngspice internally converts them to lowercase.So after the **.control** block failed, so there is no active plot.

```text
# Error comes like that 
ngspice 1 -> display
There are no vectors currently active.
```
```bash
#rectifying error by reload the circuit
source NETLIST/21muxprelayout.cir
source /home/neha/vsd_projects/avsdmux2x1_3v3/NETLIST/21muxprelayout.cir
run
display all
#error resolved now plotting waveform separately for clear cerification
plot select
plot i0 out
plot i1 out
```
![image alt](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/4bac2d534f562ccafb962f88b28660840163a536/images/2to1_presimulation.jpg.jpeg)

#### Understand the layout

```bash
cd ~/vsd_projects/avsdmux2x1_3v3/Layout
magic 21muxlayout.mag
```
Looking at layout i can see Green = Diffusion (active region), Red = Polysilicon (gate), Blue = Metal1 and Black hatched region = N-well (PMOS region). A transistor is formed where the red polysilicon crosses the green diffusion.
So simply looking for every red–green intersection. In layout there are 6 such intersections, corresponding to: 3 PMOS (top) and 3 NMOS (bottom). Also identified all the transistors example the middle of the layout.You should see:
one PMOS at the top, one NMOS directly below it, both sharing the same vertical red polysilicon line. That is the inverter (M5 + M6). The gate is connected to Select. The node joining them is N001 (!Select).
![image alt](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/182b20eeaf38f1a580444ab9908869ea2257ab6a/images/Screenshot%20From%202026-06-26%2014-35-00.png)


#### Verify DRC, LVS and Extract netlist
There is no DRC and LVS error in report. Magic converts the physical layout into an electrical netlist through extraction. Typical commands are which generates the extracted SPICE netlist representing the implemented layout.

```tcl
extract all
ext2spice
```
#### Post-Layout Simulation
Analyze and run the  extracted layout netlist:

```bash
cd ~/vsd_projects/avsdmux2x1_3v3
less NETLIST/21muxpostlayout.spice
ngspice NETLIST/21muxpostlayout.spice
```
`21muxpostlayout.spice.` is most important file because it shows how the layout is converted back into a circuit.Excellent. This is the **most important file** because it shows how the **layout is converted back into a circuit**. Let's understand few examples: 

- **1. Comment `* SPICE3 file created from 21layout.ext - technology: scmos`** This tells us: It is **automatically generated** by Magic. and It comes from the extracted file `21layout.ext`.

- **2. Scale `.option scale=0.1u`** Magic stores dimensions in **lambda units**. This line tells SPICE:1 layout unit = 0.1 µm.

- **3. Model files `.include NMOS-180nm.lib and .include PMOS-180nm.lib`** These contain the actual transistor models. Without them, SPICE would not know how NMOS and PMOS behave.

- **4. Transistors** Instead of M1 M2... M6 Magic renamed them as M1000 M1001...M1005.The names **do not matter**. Only the connections matter.For example `M1005 out a_22_49# I0 VSS CMOSN` means Drain = out, Gate  = a_22_49#, Source= I0 and Bulk  = VSS. Compare with your pre-layout `M1 I0 N001 out vee n_mos` Notice that N001 became a_22_49#.

- **5. Why no L=0.18u and W=0.9u?** Because .option scale = 0.1. Therefore Length 2 × 0.1 = 0.2 µmapproximately 0.18 µm Similarly Width 8 × 0.1 = 0.8 µm approximately 0.9 µm.

- **6. What are these(ad=,pd=,as=,ps=)?** These were **not** in your schematic. Magic extracted them automatically. They mean ad = drain area,pd = drain perimeter,as = source area,ps = source perimeter These create junction capacitances.This is why post-layout simulation is more realistic.

- **7. Voltage sources** Exactly the same as pre-layout. Only one difference: Select in Pre-layout(+0.5 ↔ -0.5) but in Post-layout(+1 ↔ -1).


##### One interesting observation

- This extracted netlist is **much cleaner than many industrial post-layout netlists**. It contains transistor geometry but **does not include explicit extracted parasitic resistors and capacitors** (e.g., `R...` or `C...` elements). That means the extraction used here is a **basic transistor extraction with parasitic element**, suitable for functional verification, rather than a full parasitic RC extraction used for sign-off.
![image alt](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/fa6932c18d5208319ad3c35575c97293c663fc00/images/2to1_postsimulation.jpg.jpeg)

- Post-layout parasitics introduce a small RC delay that smooths switching transitions, reducing the apparent spikes compared to the ideal pre-layout simulation.


# Section 2 - Analog macro integration 
## Learning 1 : What is AMUX2_3V.mag? and why needed?
### What is AMUX2_3V?
It is same as `avsdmux2x1_3v3` but The original repository (avsdmux2x1_3v3) contains a **180nm OSU library** layout.It cannot be used directly in OpenLane because OpenLane uses **SKY130**. So opened Magic with the SKY130 technology and drew the same 2:1 transmission-gate MUX manually which saved as `AMUX2_3V.mag`.
```bash
magic -T sky130A.tech
```
#### Tips for IP design using sky130 technology
- According to the height of the macro, the number of supply nets (power and ground) must be changed. For example, for dual height macro, there must be 3 supply nets( VDD-VSS-VDD). This is because it would be placed between standard cells and the power and ground net connectivity would be lost.
- The supply nets must be horizontal for them to fit into the rails.
- The size of the supply nets are fixed as shown below. The dimensions must be followed.
![image alt](https://github.com/praharshapm/vsdmixedsignalflow/raw/master/images/power%20dimensions.JPG)
- The top level cell does not include the whole layout.
![image alt](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/a45a253a7327df3176b652c52abf753d8230b21b/images/Screenshot%20From%202026-06-28%2000-01-26.png)

#### Verify DRC 
DRC (Design Rule Check) is a verification step in VLSI design where the layout is checked against the foundry’s manufacturing rules. In simple words, it ensures that the chip layout follows spacing, width, and overlap etc rules so the design can be fabricated correctly.Inside Magic Expected: Total DRC errors = 0
```tcl
drc check
drc count
drc why
```
#### Extract SPICE
An extracted SPICE netlist is the text file generated after running layout extraction in Magic. It contains the transistor devices (MOSFETs) and their connections, plus basic parasitic elements (like capacitances) derived from the layout.Generated: AMUX2_3V.spice
```tcl
extract all
# Tell When you generate the SPICE netlist, write it in an LVS-friendly format
ext2spice lvs
ext2spice
```
#### LVS (Layout Versus Schematic) Checks 

It is a verification step in chip design where the extracted netlist from the layout is compared against the original schematic/netlist. In simple words, it checks that the layout we drew really matches the intended circuit connectivity.This repository is **not intended to demonstrate the complete custom IC design flow**. Its purpose is to show how an **already-designed analog macro is integrated** into a digital OpenLane/OpenROAD flow. Since schematic spice netlist is missing i am not able to perform LVS Checks. 

# Section 3 - Required input file generation using AI  
## Learning : LEF, LIB and Verilog File generation
### LEF File (Library Exchange Format) Generation

LEF gives physical abstract information like cell width/height, pin locations, routing blockages, metal layers. Used during floorplan and placement.Generated `AMUX2_3V.lef`
```tcl
lef write AMUX2_3V
```
### Verilog File generation using raven-picorv32 

The verilog file for analog multiplexer can be procured from [click here](https://github.com/efabless/raven-picorv32/blob/master/verilog/AMUX2_3V.v). To get the repository:
```bash
git clone https://github.com/efabless/raven-picorv32.git
```
#### Why clone raven-picorv32?

Because OpenLane cannot synthesize only an analog macro. OpenLane needs a top-level digital design. That top-level design already exists in the raven-picorv32 repository.We are not copying the layout, we copy the top-level Verilog that instantiates the analog MUX.![shown here]()
```text
raven-picorv32
      │
      ├── CPU
      ├── SPI
      ├── GPIO
      └── Analog MUX (to be replaced by AMUX2_3V)
```
#### Why is AMUX2_3V.v needed?

During synthesis,OpenLane cannot read AMUX2_3V.mag or AMUX2_3V.lef. It only understands Verilog.So AMUX2_3V.v acts as the black-box declaration.
![image alt](https://github.com/praharshapm/vsdmixedsignalflow/blob/master/images/amux.JPG)

```text
# Complete picture
Analog Design
------------------------
AMUX2_3V.mag
        │
        ├──► LEF
        ├──► LIB
        └──► Verilog Wrapper

Digital Design
------------------------
raven-picorv32
        │
        └── design_mux.v
              │
              └── instantiates AMUX2_3V

OpenLane
------------------------
Synthesis  ← uses Verilog
Floorplan  ← uses LEF
Placement  ← uses LEF
Timing     ← uses LIB
Routing
GDSII
```
### Analyzing generated LEF file

The lef file ![found here]() is matched with verilog wrapper ![found here]. But in given reference repo there was a pin issue.

#### what is a "pin issue"?
- When an analog macro is used inside OpenLane/OpenROAD, the digital tools cannot read a Magic layout (.mag). Instead, they read the LEF file which tells What is the size of the macro?, Where are the pins?, Which pins are input/output/power?, Where routing is allowed or blocked? Therefore, every pin in the layout must be exported correctly into the LEF. But before Pins were not declared as Magic ports, magic had a label. To convert the labels into pins, a command called port can be used in magic.

##### Resolving pin issue for the labels on metal layers:
- Select the area under which the label is present. 

![image alt](https://github.com/praharshapm/vsdmixedsignalflow/blob/master/images/vdd_select.png)

- In the tkcon window type 
  ```tcl 
  port make
  ```
- To verify if the port is made 
    ```javascript 
    port name
    ```
![image alt](https://github.com/praharshapm/vsdmixedsignalflow/blob/master/images/port.png)  

- Similarly, carry out the same process for other labels.
  
##### Resolving pin issue for the labels on polysilicon layers:
- Type `g` to enable the grid option
- delete the label on `poly` layer by selecting the area where label is present and typing the following in tkcon window
   ```javascript 
  erase labels
  ```
- Connect a `polycont` layer on the `poly` on one side
- To the `polycont`, connect a `locali` layer . 
- Remove DRC errors if any.
- Create a label on `locali` layer , by selecting a point on the layer and in tkcon window, typing
  ```javascript 
  label 'name_of_label'
  ```
- Continue the same process for turning a label into port for rest.
- Now, dump out the LEF file again by using 
```javascript 
lef write AMUX2_3V.lef
```
All the pins and their descriptions can now be seen.

#### what is a OBS?
At the end of LEF, we have obs section Meaning OBS = Obstruction. It tells the router **Do NOT route wires through this region**. These are portions of the layout already occupied by transistors, diffusion, polysilicon, contacts, etc.
```text
OBS
   LAYER li1 ;
      RECT ...
      RECT ...
      RECT ...
END
```
##### Why does the repo mention polysilicon?

During LEF generation, Magic converts layout geometry into: Pins (PIN) and Obstructions (OBS). If a polysilicon label is not converted into a port correctly, Magic may incorrectly treat it as an obstruction instead of a pin.So the repo says If OBS is missing, something likely went wrong during LEF generation.

#### What is CLASS CORE issue?

Our LEF contains CLASS CORE Meaning: This macro is intended to be placed inside the core area of the chip. Other possible classes include `CLASS BLOCK`  , `CLASS PAD` , `CLASS RING`. For our analog multiplexer `CORE` is correct because it is used inside the digital design. This line can be added using the following command in the tkcon window:
```javascript 
 property LEFclass CORE
```

#### What is ORIGIN 0 0

Our LEF says `ORIGIN 0.000 0.000` .This means the lower-left corner of the layout starts at (0,0). OpenLane assumes every macro begins at the origin. Suppose our layout actually starts at (4.5 , 2.1) Then every pin coordinate becomes shifted. Example Instead of I0 = (2,3) ,OpenLane would think I0=(6.5,5.1) from this Routing becomes incorrect.Therefore the layout is moved so that Lower Left = (0,0)

##### In order to get this: 
- **1. first find out the current co-ordinates of origin by:** selecting the whole layout and type the following in tkcon window
```javascript 
box
```
From this, llx and lly are X and Y co-ordinates respectively.

- **2. setting X co-ordinate to 0:**
```javascript 
move origin right 'llx' um
```
- **3. setting Y co-ordinate to 0:**
```javascript 
move origin bottom -`lly`um
```
- **4. checking if the origin has shifted to (0,0):** first find out the current co-ordinates of origin by:
```javascript 
box
```
Now, the llx and lly should have the value of 0.

####  SITE unithddbl

Our LEF contains `SITE unithddbl` Meaning The macro is compatible with the standard cell rows used by the SKY130 HD library. Every standard cell has a fixed height. If our macro height doesn't match, it cannot sit inside the placement rows.To set this, type the following from tkcon window:
```javascript 
 property LEFsite unithddbl
```
#### SIZE

Our LEF SIZE 8.740 BY 5.440 meaning Width = 8.74 µm and Height = 5.44 µm. The repo says Height should be 2.72 µm or 5.44 µm. Why? Because SKY130 standard-cell rows have fixed heights. For example Standard Cell Height = 2.72 µm.If your macro is 5.44 µm = 2 × 2.72 then it fits exactly into two placement rows. Otherwise OpenLane cannot place it correctly.This can be achieved by fixing a bounding box of 5.44 um.
```javascript 
property FIXED_BBOX {0 24 874 568}
```

#### DIRECTION

Our LEF contains PIN I0 DIRECTION INPUT Meaning Signal enters macro. Similarly PIN out DIRECTION OUTPUT meaning Signal leaves macro. Power pins PIN VDD DIRECTION INOUT because Power is shared throughout the chip. Select the part which contains the pin and type the following in tkcon window:
- **1. For Power and Ground pins:**
```javascript 
port class inout
```
- **2. For Input pins:**
```javascript 
port class input
```
- **3. For Output pins:**
```javascript 
port class output
```

#### USE

Our LEF contains USE SIGNAL or USE POWER or USE GROUND Meaning The router now knows I0 -> Signal, VDD -> Power Rail
and VSS -> Ground Rail. Without this information, the power distribution network (PDN) generation would fail. Select the part which contains the pin and type the following in tkcon window:
- **1. Power pin:**
```javascript 
port use power
```
- **2. Ground pin:**
```javascript 
port use ground
```
- **3. Other pins:**
```javascript 
port use signal
```
#### property FIXED_BBOX
property FIXED_BBOX {0 24 874 568}. This fixes the macro boundary. Think of it as drawing a rectangle around the macro. OpenLane only sees this rectangle. Everything must lie inside it.
```text
+-------------------------+
|                         |
|      Entire Macro       |
|                         |
+-------------------------+
```

 Ultimately, after configuring all the lines for LEF, create a LEF file by typing the following in tkcon window:
```javascript 
lef write AMUX2_3V.lef
```
### Writing LIB file
During synthesis, OpenLane uses Yosys, which needs timing information. The LEF only tells: Macro size, Pin locations and Routing information. It does not tell: Delay, Timing and Logic function. That's why we need a `.lib file`. 
#### Why use a Perl script?
 LIB file can be got by using a perl script, which converts verilog file to LIB file. To view the script, go to `vim verilog_to_lib.pl`.
 #### Why change the pin names?
 The verilog file is obtained from the efabless github page. But, the names of the pins defined in the verilog file and the layout and LEF file obtained above may be different beacuse OpenLane would think these are different signals and fail to connect the macro. Therefore, change the pin names in the verilog file accordingly and then obtain the LIB file by using the perl script by typing the following on terminal

```javascript 
perl verilog_to_lib.pl AMUX2_3V AMUX2_3V
```
The Analog macro is now ready.



</details>

<details> 
	<summary> WEEK 3 -  Use that analog macro inside a complete digital chip TASK 3 </summary>

# Section 1 - Asking OpenLane to build an entire chip that contains this analog macro
## Learning : Experiments with Openlane and sky130 
### Building Top chip
OpenLane organizes every chip as one design thats why need a folder. Inside it, everything related to this chip will be stored.
```bash
cd designs
mkdir design_mux
```
### Export PDK(Process design kit)
It contains Technology rules, Standard cells,DRC rules, Layers, Via definitions, Models and Libraries. OpenLane must know Where is SKY130? That's why To set-up the project, run the following :
Go to the `~/openlane_working_dir/openlane` and execute the following:
```javascript 
export PDK_ROOT=<absolute path to where skywater-pdk and open_pdks reside>
```
### Running docker and preparing the project
```javascript 
docker run -it -v $(pwd):/openLANE_flow -v $PDK_ROOT:$PDK_ROOT -e PDK_ROOT=$PDK_ROOT -u $(id -u $USER):$(id -g $USER) openlane:rc2
```
This starts the OpenLane environment.Inside Docker you now have Yosys,  OpenROAD, Magic, Netgen, KLayout, TritonRoute, FastRoute Everything is ready.
```javascript 
 ./flow.tcl -design design_mux -init_design_config
```
This command does not run synthesis. It only prepares the project. OpenLane creates something like The important file is config.tcl 
```text
design_mux/
config.tcl
src/
runs/
...
```
#### Why do we need config.tcl?
OpenLane doesn't know Top module name Clock, RTL file, Macro LEF, Macro LIB, Macro placement. All this information is stored inside `config.tcl` Think of it as Project Settings from here the real RTL to GDS flow starts.

## Learning 2 : Adding Input Files
### Ading Verilog files?

`design_mux.v`. This is the **top-level design**. It instantiates everything. Without it, OpenLane does not know what circuit to build. Think of it as the entire chip. Example:

```text
design_mux
│
├── SPI Interface
├── Control Logic
├── AMUX2_3V
└── Other logic
```

* **AMUX2_3V.v** This is **our analog macro wrapper**. Remember It is **not synthesized**.It only tells synthesis
* **raven_spi.v** Implements the SPI controller. The chip communicates with the outside world through SPI.
* **spi_slave.v** Implements the SPI slave logic. 

### Adding LEF
Copy `AMUX2_3V.lef` into `design_mux/src/lef/` **Why?** During placement, OpenLane must know  Macro size, Pin locations, Blockages. This information comes from LEF.

# Section 2 - Interactive Flow from RTL to GDS
## Learning 1 : Process of RTL to GDS   
### Interactive Flow
To harden a macro, the automated flow for Openlane cannot by used. Instead an interactive script should be used. 

Go to the `~/openlane_working_dir/openlane` and execute the following:
```javascript 
export PDK_ROOT=<absolute path to where skywater-pdk and open_pdks reside>
```
```javascript 
docker run -it -v $(pwd):/openLANE_flow -v $PDK_ROOT:$PDK_ROOT -e PDK_ROOT=$PDK_ROOT -u $(id -u $USER):$(id -g $USER) openlane:rc2
```
A bash window will open. In the bash window, the interactive flow is executed.
```javascript 
 ./flow.tcl -design design_mux -interactive
```


### Loading OpenLane package

```tcl
package require openlane 0.9
```
This loads all OpenLane commands. Without it commands would not exist.

### Preparing the design

```tcl
prep -design design_mux -overwrite
```
This command does several things Reads `config.tcl` Creates a new run directory, Loads the PDK, Loads technology files, Creates working directories, Initializes the design database


### Loading the LEF

```tcl
set lefs [glob $::env(DESIGN_DIR)/src/lef/*.lef]
```
Meaning Search `design_mux/src/lef/` for every `*.lef` file. If there are any lef file all will be collected.

### Registering the LEF

```tcl
add_lefs -src $lefs
```
This tells OpenLane "These are my hard macros." Without this command, during floorplanning, OpenLane would say `Cannot find macro`. because it has no physical information.

## Learning 2 : Logic Design
### Running synthesis

```tcl
run_synthesis
```
This is the **first actual implementation step**. Yosys reads `design_mux.v` and starts synthesizing. Yosys is an open‑source synthesis tool that converts Verilog RTL designs into gate‑level netlists. In simple words, it takes your high‑level hardware description and maps it onto logic gates from a standard cell library, making the design ready for place‑and‑route.

#### What about AMUX2_3V?
This is important. Yosys **does not synthesize** it. Instead, it sees

```verilog
AMUX2_3V mux1(...)
```
and says "This is already an existing hard macro." It keeps it as a black box. We'll obtain `results/synthesis/`
containing design_mux.synthesis.v, Reports, Statistics, Timing.


### What is Floorplanning?

This is where OpenLane decides "Where should every block be placed?" At this stage The chip size is determined, Power rails are planned, The analog macro (`AMUX2_3V`) is allocated space and Standard-cell rows are created around it. No routing has happened yet—OpenLane is only deciding **where everything will physically sit** on the chip.This marks the transition from **logical design (RTL and synthesis)** to **physical design (floorplanning, placement, CTS, routing)**, where our analog macro is treated as a fixed hard block and the rest of the digital logic is arranged around it. After floorplanning, the layout can be viewed in magic using the merged LEF and DEF file produced. The DEF file.

```javascript 
magic -T ~/sky130A.tech lef read ~/merged.lef def read design_mux.floorplan.def
```

![image alt](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/a45a253a7327df3176b652c52abf753d8230b21b/images/floorplan.jpg.jpeg)


## Learning 3 : Physical Design
### IO Placement

```tcl
place_io
```
This places the **I/O pins of the top-level design** around the boundary of the chip. These are **top-level chip pins**, **not** the pins of the AMUX macro.

#### Global Placement

```tcl
global_placement_or
```
**Purpose** is that OpenROAD decides approximately where every standard cell should go. Imagine we have `1000 standard cells` .Initially everything is overlapping.

```
□□□□□□□□□□□□□□□□□□□□□□
```
Global placement spreads them out.

```
□ □ □ □ □ □ □
   □ □ □ □
□ □ □ □ □ □
```

No exact locations yet. The analog macro (AMUX2_3V) is **fixed**. Only digital cells move.

#### Detailed Placement

```tcl
detailed_placement
```
Now every cell is  sits exactly on legal placement rows. For example Before

```
□
    □
       □
```

After

```
□□□□□□□□□□□□
□□□□□□□□□□□□
□□□□□□□□□□□□
```

#### Tap and Decap Insertion

```tcl
tap_decap_or
```

This inserts Tap Cells. Tap cells connect **P-substrate <-> N-well** to **VSS <-> VDD** This prevents Latch-up and Floating wells. 

#### Decap Cells

Decoupling capacitors reduce Power Supply Noise, Voltage Drop,Switching Noise. They stabilize the power rails. After insertion placement changes,so OpenLane again performs to legalize all cells.

```tcl
detailed_placement
```
After final placement, the layout can be viewed in magic using merged LEF and DEF file. 

```bash
magic -T sky130A.tech \
lef read merged.lef \
def read design_mux.placement.def
```

![image alt](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/a45a253a7327df3176b652c52abf753d8230b21b/images/placement.jpg.jpeg)

### PDN Generation

```tcl
gen_pdn
```

PDN means Power Delivery Network. OpenLane generates VDD Rails, VSS Rails, Metal Straps, Power Grid. For example

```picture
================== VDD

||||||||||||||||||

================== VSS
```

Every standard cell and the analog macro are connected to this power network. Without PDN Nothing receives power.


### Routing

```tcl
run_routing
```
Now OpenROAD connects every signal. Before routing no wires are all electrically connected.After routing, the layout can be viewed in magic using merged LEF and DEF file.

```bash
magic -T sky130A.tech \
lef read merged.lef \
def read design_mux.def
```
Now the DEF contains Placement + Routing so Magic displays both cells and interconnects.

![image alt](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/7c90acfd0ceda0fb8fb3031749bfaa332e5b2af9/images/routing.jpg.jpeg)


# Section 3 - Post routing verification to gds file generation 
## Learning  : Post routing verification and final Layout generation 
### Post-layout DRC Cleaning

```tcl
run_magic_drc
```
Magic checks Minimum spacing Minimum width, Metal overlap, Via spacing, Enclosure and Technology rule violations.If violations exist, they must be fixed. opens the DRC layout so you can inspect the errors. **My mistake** is that i am using below command to open mag file, which rectified after using **AI**. 
```bash
magic -T ../sky130A.tech lef read results/merged.lef def read results/DRC/design_mux.drc.mag
```
![image alt](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/main/images/design_drc_mag.png)

**Why did DRC=10242 appear?**

The DRC=10242 indication was not due to actual layout violations. It occurred because the layout was opened using an incorrect command that mixed LEF/DEF loading with a Magic (.mag) layout. As a result, Magic loaded or retained **DRC marker tiles**(DRC marker tiles are small annotation regions that Magic creates to mark the locations where DRC violations were detected during a previous DRC run. These markers are only for visualization and debugging—they do not represent current violations.) instead of performing a fresh DRC verification. Running drc count confirmed 0 actual DRC violations, indicating that the displayed error tiles were only stored markers and not real design-rule errors.So the correct way to verify drc is 
 
 ```bash
magic -T ../sky130A.tech results/DRC/design_mux.drc.mag
```
![image alt](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/main/images/design_drc_mag.png)


### Final Layout

```tcl
run_magic
```
The final layout output is in the form of `design_mux.mag` and `design_mux.gds`. Magic converts the routed DEF into the final layout. 
```javascript 
magic -T ../sky130A.tech results/Layout/design_mux.mag
```
![image alt](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/main/images/design_mux_layout.png)

#### What is GDS|| file

After successful routing and DRC verification, the final GDSII file was generated using the Magic backend in OpenLane. The GDSII file represents the complete physical layout of the design and is the standard format delivered to semiconductor foundries for fabrication. The generated GDSII was then opened in KLayout for final visual inspection of the chip layout, routing, standard cells, and embedded analog macro.KLayout is used to inspect the final chip layout before fabrication.
```bash
# Launch KLayout
klayout
# navigate to
File → Open → design_mux.gds
# To correctly display Sky130 layers
Tools → Manage Technologies → sky130
```
![image alt](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/main/images/design_mux_gds.png)
![image alt](https://github.com/Neha856/AI_Assisted_Analog_and_MixedSignal_Internship/blob/main/images/design_mux_gds_zoom.png)


##### Important Notes Why remove VDD/VSS from the Verilog?

The analog macro's **physical layout** already contains the power connections. If the wrapper Verilog also declares power pins in a way that conflicts with the integration flow, OpenLane may create duplicate or inconsistent connections. The repository's wrapper keeps the functional interface simple (I0, I1, `select`, `out`) while the physical power connectivity is handled by the LEF/layout and the generated PDN.

##### Why add the LEF twice?

We saw `config.tcl + add_lefs`. This is because:

* `config.tcl` tells OpenLane that the macro exists as part of the project configuration.
* `add_lefs` loads the macro's LEF into the current interactive OpenLane session so the tools can use its physical abstract immediately.


### Complete Mixed-Signal Flow


```text
                    ANALOG DESIGN
                    =============

Schematic
      │
      ▼
Magic Layout (.mag)
      │
      ▼
DRC
      │
      ▼
Extraction (.ext)
      │
      ▼
Post-layout SPICE (.spice)
      │
      ▼
LEF generation
      │
      ▼
Verilog wrapper (.v)
      │
      ▼
LIB generation (.lib)

──────────────────────────────────────────────
         Analog macro is now ready
──────────────────────────────────────────────

               DIGITAL FLOW
               ============

RTL (Top-level Verilog)
      │
      ▼
Synthesis (Yosys)
      │
      │  Uses:
      │  • Standard-cell LIB
      │  • AMUX2_3V.lib
      ▼
Gate-level Netlist
      │
      ▼
Floorplanning
      │
      │  Uses:
      │  • AMUX2_3V.lef
      ▼
IO Placement
      │
      ▼
Global Placement
      │
      ▼
Detailed Placement
      │
      ▼
Tap/Decap Insertion
      │
      ▼
PDN Generation
      │
      ▼
Routing
      │
      ▼
DRC
      │
      ▼
Final Layout (.mag/.gds)
```

This completes the end-to-end picture: We first create and verify an analog hard macro, then provide its LEF, LIB, and Verilog wrapper so OpenLane can integrate it with synthesized digital logic, place it on the chip, connect power and signals, verify the layout, and generate the final manufacturable design.

</details>

<details> 
	<summary> Tools & Environment </summary>
	

| Tool | Purpose |
|------|---------|
| **Magic VLSI** | Used for custom analog layout design, DRC verification, parasitic extraction (`.ext`), SPICE netlist generation, LEF generation, and GDSII creation. |
| **NGSpice** | Used to perform pre-layout and post-layout transient simulations and compare circuit performance before and after layout parasitics. |
| **OpenLane** | Complete open-source RTL-to-GDSII flow used for synthesis, floorplanning, placement, PDN generation, routing, DRC, and final layout generation. |
| **OpenROAD** | Physical design engine within OpenLane responsible for floorplanning, placement, routing, and physical design optimization. |
| **Yosys** | RTL synthesis tool that converts Verilog RTL into a gate-level netlist using the Sky130 standard cell library. |
| **Magic Extractor** | Extracts the SPICE netlist from the physical layout for post-layout simulation and verification. |
| **KLayout** | Used to visualize and inspect the final GDSII layout before fabrication. |
| **Sky130 PDK** | Open-source 130 nm Process Design Kit providing technology files, design rules, standard cells, device models, LEF/Liberty files, and layout layers. |
| **Docker** | Provides a reproducible environment for running the OpenLane/OpenROAD flow without dependency conflicts. |
| **Git & GitHub** | Used for version control, project documentation, and collaboration. |
| **Perl (`verilog_to_lib.pl`)** | Converts the Verilog description of the analog macro into a Liberty (`.lib`) file for synthesis and timing integration. |
							   

</details>


<details> 
	<summary> Acknowledgements </summary>

* [Kunal Ghosh](https://github.com/kunalg123), Co-founder, VSD Corp. Pvt. Ltd.
* [Nickson P Jose](https://github.com/nickson-jose), Physical Design Engineer, Intel Corporation.
* [R. Timothy Edwards](https://github.com/RTimothyEdwards), Senior Vice President of Analog and Design, efabless Corporation.
* [praharshapm] (https://github.com/praharshapm/vsdmixedsignalflow).


</details>



























  






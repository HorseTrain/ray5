// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (lin64) Build 6511674 Tue Jun 16 11:01:26 MDT 2026
// Date        : Sat Oct 17 17:12:59 2026
// Host        : raymond-MS-7C91 running 64-bit Ubuntu 26.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/raymond/Desktop/ray5/vivdo/mig_interface_ex/mig_interface_ex.gen/sources_1/ip/clock_wizzard/clock_wizzard_stub.v
// Design      : clock_wizzard
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s50csga324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CORE_GENERATION_INFO = "clock_wizzard,clk_wiz_v6_0_19_0_0,{component_name=clock_wizzard,use_phase_alignment=true,use_min_o_jitter=false,use_max_i_jitter=false,use_dyn_phase_shift=false,use_inclk_switchover=false,use_dyn_reconfig=false,enable_axi=0,feedback_source=FDBK_AUTO,PRIMITIVE=MMCM,num_out_clk=3,clkin1_period=10.000,clkin2_period=10.000,use_power_down=false,use_reset=true,use_locked=true,use_inclk_stopped=false,feedback_type=SINGLE,CLOCK_MGR_TYPE=NA,manual_override=false}" *) 
module clock_wizzard(out_100mhz, out_200mhz, out_400mhz, reset, 
  locked, in_100mhz)
/* synthesis syn_black_box black_box_pad_pin="reset,locked,in_100mhz" */
/* synthesis syn_force_seq_prim="out_100mhz" */
/* synthesis syn_force_seq_prim="out_200mhz" */
/* synthesis syn_force_seq_prim="out_400mhz" */;
  output out_100mhz /* synthesis syn_isclock = 1 */;
  output out_200mhz /* synthesis syn_isclock = 1 */;
  output out_400mhz /* synthesis syn_isclock = 1 */;
  input reset;
  output locked;
  input in_100mhz;
endmodule

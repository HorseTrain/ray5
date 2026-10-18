-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_wizzard is
  Port ( 
    out_100mhz : out STD_LOGIC;
    out_200mhz : out STD_LOGIC;
    out_400mhz : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    in_100mhz : in STD_LOGIC
  );

  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of clock_wizzard : entity is "clock_wizzard,clk_wiz_v6_0_19_0_0,{component_name=clock_wizzard,use_phase_alignment=true,use_min_o_jitter=false,use_max_i_jitter=false,use_dyn_phase_shift=false,use_inclk_switchover=false,use_dyn_reconfig=false,enable_axi=0,feedback_source=FDBK_AUTO,PRIMITIVE=MMCM,num_out_clk=3,clkin1_period=10.000,clkin2_period=10.000,use_power_down=false,use_reset=true,use_locked=true,use_inclk_stopped=false,feedback_type=SINGLE,CLOCK_MGR_TYPE=NA,manual_override=false}";
end clock_wizzard;

architecture stub of clock_wizzard is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
begin
end;

-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mig_interface is
  Port ( 
    ddr3_dq : inout STD_LOGIC_VECTOR ( 15 downto 0 );
    ddr3_dqs_p : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr3_dqs_n : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr3_addr : out STD_LOGIC_VECTOR ( 13 downto 0 );
    ddr3_ba : out STD_LOGIC_VECTOR ( 2 downto 0 );
    ddr3_ras_n : out STD_LOGIC;
    ddr3_cas_n : out STD_LOGIC;
    ddr3_we_n : out STD_LOGIC;
    ddr3_reset_n : out STD_LOGIC;
    ddr3_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_cs_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_dm : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr3_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
    app_addr : in STD_LOGIC_VECTOR ( 27 downto 0 );
    app_cmd : in STD_LOGIC_VECTOR ( 2 downto 0 );
    app_en : in STD_LOGIC;
    app_wdf_data : in STD_LOGIC_VECTOR ( 63 downto 0 );
    app_wdf_end : in STD_LOGIC;
    app_wdf_mask : in STD_LOGIC_VECTOR ( 7 downto 0 );
    app_wdf_wren : in STD_LOGIC;
    app_rd_data : out STD_LOGIC_VECTOR ( 63 downto 0 );
    app_rd_data_end : out STD_LOGIC;
    app_rd_data_valid : out STD_LOGIC;
    app_rdy : out STD_LOGIC;
    app_wdf_rdy : out STD_LOGIC;
    app_sr_req : in STD_LOGIC;
    app_ref_req : in STD_LOGIC;
    app_zq_req : in STD_LOGIC;
    app_sr_active : out STD_LOGIC;
    app_ref_ack : out STD_LOGIC;
    app_zq_ack : out STD_LOGIC;
    ui_clk : out STD_LOGIC;
    ui_clk_sync_rst : out STD_LOGIC;
    init_calib_complete : out STD_LOGIC;
    sys_clk_i : in STD_LOGIC;
    clk_ref_i : in STD_LOGIC;
    device_temp : out STD_LOGIC_VECTOR ( 11 downto 0 );
    sys_rst : in STD_LOGIC
  );

end mig_interface;

architecture stub of mig_interface is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
begin
end;

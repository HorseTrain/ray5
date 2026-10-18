--------------------------------------------------------------------------------
-- Copyright (c) 2026 Mataka Studio. All rights reserved.
-- 
-- @brief Synchronous memory test specifically for vivado and mig. 
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.all; 
use work.test_bench_globals.all;
use work.core_p.all;
use work.ray5_globals_p.all;
use work.memory_interface_p.all;

entity test_memory_interface is 

end entity;

architecture tb of test_memory_interface is 

    ----------------------------------------------------------------------------
    -- @brief 100 mhz clock input.
    ----------------------------------------------------------------------------
    signal sys_clk : std_logic := '0';

    ----------------------------------------------------------------------------
    -- @brief 200 mhz clock input.
    ----------------------------------------------------------------------------
    signal ref_clk : std_logic := '0';

    ----------------------------------------------------------------------------
    -- @brief Clock input.
    ----------------------------------------------------------------------------
    signal clock_input_200mhz : std_logic := '0';

    ----------------------------------------------------------------------------
    -- @brief Memory interface bus.
    ----------------------------------------------------------------------------
    signal memory_interface_bus : memory_interface_bus_t; 

    ----------------------------------------------------------------------------
    -- Local VHDL constants acting as your single source of truth
    ----------------------------------------------------------------------------
    constant TB_DM_BITS   : integer := 2;
    constant TB_BA_BITS   : integer := 3;
    constant TB_ADDR_BITS : integer := 15;
    constant TB_DQ_BITS   : integer := 16;
    constant TB_DQS_BITS  : integer := 2;
    
    ----------------------------------------------------------------------------
    -- Ddr3 model from verilog.
    ----------------------------------------------------------------------------
    component ddr3_model is
        generic ( 
            DM_BITS   : integer := TB_DM_BITS;      -- x16 requires 2 bits
            BA_BITS   : integer := TB_BA_BITS;      -- 3 Bank bits
            ADDR_BITS : integer := TB_ADDR_BITS;    -- 15 Address bits
            DQ_BITS   : integer := TB_DQ_BITS;      -- 16 Data bits
            DQS_BITS  : integer := TB_DQS_BITS      -- 2 Strobe bits
        );
        port (
            rst_n   : in    std_logic;
            ck      : in    std_logic;
            ck_n    : in    std_logic;
            cke     : in    std_logic;
            cs_n    : in    std_logic;
            ras_n   : in    std_logic;
            cas_n   : in    std_logic;
            we_n    : in    std_logic;
            odt     : in    std_logic;
             
            ba      : in    std_logic_vector(BA_BITS-1 downto 0);      
            addr    : in    std_logic_vector(ADDR_BITS-1 downto 0);     
            dm_tdqs : inout std_logic_vector(DM_BITS-1 downto 0);      
            tdqs_n  : out   std_logic_vector(DM_BITS-1 downto 0); 
            dq      : inout std_logic_vector(DQ_BITS-1 downto 0);     
            dqs     : inout std_logic_vector(DQS_BITS-1 downto 0);      
            dqs_n   : inout std_logic_vector(DQS_BITS-1 downto 0)       
        );
    end component;
    
begin

    sys_clk <= not sys_clk after 5 ns;
    ref_clk <= not ref_clk after 2.5 ns;

    stim_proc : process 
    begin

        wait until memory_interface_bus.outputs.ready = '1';

        report "Memory interface is ready, beginning tests.";

        finish;

    end process;

    ----------------------------------------------------------------------------
    -- Rout clocks into interface. 
    ----------------------------------------------------------------------------
    memory_interface_bus.inputs.system_clock <= sys_clk;
    memory_interface_bus.inputs.reference_clock <= ref_clk;

    memory_interface : entity work.memory_interface 
    port map (
        inputs => memory_interface_bus.inputs, 
        outputs => memory_interface_bus.outputs,

        ddr3_outputs => memory_interface_bus.ddr3_outputs, 
        ddr3_in_outs => memory_interface_bus.ddr3_in_outs
    );
    
    ----------------------------------------------------------------------------
    -- DDR3 memory model.
    ----------------------------------------------------------------------------
    uut_ddr3_model : ddr3_model
    generic map (
        DM_BITS   => TB_DM_BITS,
        BA_BITS   => TB_BA_BITS,
        ADDR_BITS => TB_ADDR_BITS,
        DQ_BITS   => TB_DQ_BITS,
        DQS_BITS  => TB_DQS_BITS
    )
    port map (
        rst_n   => memory_interface_bus.ddr3_outputs.ddr3_reset_n,
        we_n    => memory_interface_bus.ddr3_outputs.ddr3_we_n,
        ba      => memory_interface_bus.ddr3_outputs.ddr3_ba,
        addr    => '0' & memory_interface_bus.ddr3_outputs.ddr3_addr, -- Zero extend to 16 bits. 
        ras_n   => memory_interface_bus.ddr3_outputs.ddr3_ras_n,
        dm_tdqs => memory_interface_bus.ddr3_outputs.ddr3_dm, 
        cas_n   => memory_interface_bus.ddr3_outputs.ddr3_cas_n,

        odt     => memory_interface_bus.ddr3_outputs.ddr3_odt(0),
        ck      => memory_interface_bus.ddr3_outputs.ddr3_ck_p(0),
        ck_n    => memory_interface_bus.ddr3_outputs.ddr3_ck_n(0),
        cke     => memory_interface_bus.ddr3_outputs.ddr3_cke(0),
        cs_n    => memory_interface_bus.ddr3_outputs.ddr3_cs_n(0),

        dq      => memory_interface_bus.ddr3_in_outs.ddr3_dq,
        dqs     => memory_interface_bus.ddr3_in_outs.ddr3_dqs_p,
        dqs_n   => memory_interface_bus.ddr3_in_outs.ddr3_dqs_n,
        
        tdqs_n  => open 
    );



end architecture;
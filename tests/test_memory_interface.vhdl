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

begin

    sys_clk <= not sys_clk after 5 ns;
    ref_clk <= not ref_clk after 2.5 ns;

    stim_proc : process 
    begin

        wait;

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



end architecture;
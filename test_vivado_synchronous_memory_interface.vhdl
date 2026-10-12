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

entity test_vivado_synchronous_memory_interface is 


end entity;

architecture tb of test_vivado_synchronous_memory_interface is 

    ----------------------------------------------------------------------------
    -- @brief Clock input.
    ----------------------------------------------------------------------------
    signal clock_input : std_logic := '0';

    ----------------------------------------------------------------------------
    -- @brief Memory interface bus.
    ----------------------------------------------------------------------------
    signal memory_interface_bus : memory_interface_bus_t; 

begin

    clock_input <= not clock_input after TEST_BENCH_CLOCK_PERIOD_HALF;

    stim_proc : process 
    begin

        wait;

    end process;

    ----------------------------------------------------------------------------
    -- Rout clocks into interface. 
    ----------------------------------------------------------------------------
    memory_interface_bus.inputs.clock_input <= clock_input;

    memory_interface : entity work.synchronous_memory_interface 
    port map (
        inputs => memory_interface_bus.inputs, 
        outputs => memory_interface_bus.outputs,

        ddr3_outputs => memory_interface_bus.ddr3_outputs, 
        ddr3_in_outs => memory_interface_bus.ddr3_in_outs
    );

end architecture;
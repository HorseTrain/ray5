--------------------------------------------------------------------------------
-- Copyright (c) 2026 Mataka Studio. All rights reserved.
-- 
-- @brief Core init test. 
-- 
-- @description 
--      Test the init process of a core.
--------------------------------------------------------------------------------

-- TODO: Finish tests. 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.all; 
use work.test_bench_globals.all;
use work.core_p.all;
use work.ray5_globals_p.all;

entity test_cpu is 
end entity;

architecture tb of test_cpu is 

    ----------------------------------------------------------------------------
    -- @brief Clock input.
    ----------------------------------------------------------------------------
    signal clock_input : std_logic := '0';

    ----------------------------------------------------------------------------
    -- @brief LED output.
    ----------------------------------------------------------------------------
    signal led0_r : std_logic;

begin

    clock_input <= not clock_input after TEST_BENCH_CLOCK_PERIOD_HALF;

    stim_proc : process 
    begin

        

        wait;

    end process;

    ----------------------------------------------------------------------------
    -- @brief Cpu instance. 
    ----------------------------------------------------------------------------
    cpu_instance : entity work.cpu 
    port map (
        CLK100MHZ => clock_input,
        led0_r => led0_r
    );  

end architecture;
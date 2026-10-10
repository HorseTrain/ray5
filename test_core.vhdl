--------------------------------------------------------------------------------
-- Copyright (c) 2026 Mataka Studio. All rights reserved.
-- 
-- @brief Core init test. 
-- 
-- @description 
--      Test the init process of a core.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.all; 
use work.test_bench_globals.all;

entity test_core is 
end entity;

architecture tb of test_core is 

    ----------------------------------------------------------------------------
    -- @brief Clock input.
    ----------------------------------------------------------------------------
    signal clock_input : std_logic := '0';

begin

    clock_input <= not clock_input after TEST_BENCH_CLOCK_PERIOD;

    stim_proc : process 
    begin
        ------------------------------------------------------------------------
        -- Core initialization test.
        --
        -- This test ensures the core will report an initialized state (eventually lol)
        ------------------------------------------------------------------------

        wait;

    end process;

    core : entity work.core 
    port map (
        clock_input => clock_input

        -- Core status 
    );

end architecture;
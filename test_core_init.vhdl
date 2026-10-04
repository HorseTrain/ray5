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

use work.test_bench_globals.all;

entity test_core_init is 
end entity;

architecture tb of test_core_init is 

    ----------------------------------------------------------------------------
    -- @brief Clock input.
    ----------------------------------------------------------------------------
    signal clock_input : std_logic := '0';

    ----------------------------------------------------------------------------
    -- @brief Core status.
    ----------------------------------------------------------------------------
    signal core_status : unsigned (0 to 2) := (others => '0');

begin

    clock_input <= not clock_input after TEST_BENCH_CLOCK_PERIOD;

    core_test : entity work.core 
    generic map (
        register_width_bit => 3, 
        register_count_bit => 5
    )
    
    port map (
        clock_input => clock_input,

        -- Allows test bench to view core status.
        core_status_out => core_status
    );

end architecture;
--------------------------------------------------------------------------------
-- Copyright (c) 2026 Mataka Studio. All rights reserved.
-- 
-- @brief Register store tests.
--
-- @description 
--      Test the register store entity.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.all;
use work.register_store_pkg.all;

use work.test_bench_globals.all;

entity test_register_store is
end entity;

architecture tb of test_register_store is 

    ----------------------------------------------------------------------------
    -- @brief Register data template.
    ----------------------------------------------------------------------------
    constant register_store_template : register_store_template_t := new_register_store_template_t(
        5,
        3
    );

    ----------------------------------------------------------------------------
    -- @brief Clock input.
    ----------------------------------------------------------------------------
    signal clock_input : std_logic := '0';

    ----------------------------------------------------------------------------
    -- @brief Register store bus.
    ----------------------------------------------------------------------------

begin

    clock_input <= not clock_input after TEST_BENCH_CLOCK_PERIOD;

    

end architecture;
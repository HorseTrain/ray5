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
use work.test_bench_globals.all;

entity test_register_store is
end entity;

architecture tb of test_register_store is 

    ----------------------------------------------------------------------------
    -- @brief Clock input.
    ----------------------------------------------------------------------------
    signal clock_input : std_logic := '0';

    ----------------------------------------------------------------------------
    -- @brief Define types for register store. 
    ----------------------------------------------------------------------------
    package register_store_type is new work.register_store_type_p
    generic map 
    (
        register_width_bit => 5,
        register_count_bit => 3
    );

    signal register_store_bus : register_store_type.register_store_bus_t := (
        inputs => (
            clock_input => '0',
            reset => '0',
            write_enable => '0',

            index => (others => '0'),
            write_value => (others => '0')
        ),

        outputs => (
            ready => '0',
            value_out => (others => '0')
        )
    );

begin

    clock_input <= not clock_input after TEST_BENCH_CLOCK_PERIOD;

    register_test : entity work.register_store 
    generic map (
        register_store_pkg => register_store_type
    )

    port map (
        inputs => register_store_bus.inputs,
        outputs => register_store_bus.outputs
    );

    register_store_bus.inputs.clock_input <= clock_input;

end architecture;
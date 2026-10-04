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
    -- @brief Log2 of register width.
    ----------------------------------------------------------------------------
    constant register_width_bit : integer := 3;

    ----------------------------------------------------------------------------
    -- @brief Log2 of register count.
    ----------------------------------------------------------------------------
    constant register_count_bit : integer := 3; 

    ----------------------------------------------------------------------------
    -- @brief Width of registers.
    ----------------------------------------------------------------------------
    constant register_width : integer := 2** register_width_bit;

    ----------------------------------------------------------------------------
    -- @brief Number of registers.
    ----------------------------------------------------------------------------
    constant register_count : integer := 2** register_count_bit;

    ----------------------------------------------------------------------------
    -- @brief Clock input.
    ----------------------------------------------------------------------------
    signal clock_input : std_logic := '0';

    ----------------------------------------------------------------------------
    -- @brief Register reset signal.
    ----------------------------------------------------------------------------
    signal register_store_reset : std_logic := '0';

    ----------------------------------------------------------------------------
    -- @brief Register store index. 
    ----------------------------------------------------------------------------
    signal register_store_index : unsigned (0 to (register_count_bit - 1)) := (others => '0');

    ----------------------------------------------------------------------------
    -- @brief Register store write value.
    ----------------------------------------------------------------------------
    signal register_store_write_value : unsigned (0 to (register_width - 1)) := (others => '0');

    ----------------------------------------------------------------------------
    -- @brief Register store write enabled.
    ----------------------------------------------------------------------------
    signal register_store_write_enabled : std_logic := '0';

    ----------------------------------------------------------------------------
    -- Outputs 
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- @brief Register store write value.
    ----------------------------------------------------------------------------
    signal register_store_value_out : unsigned (0 to (register_width - 1));

    ----------------------------------------------------------------------------
    -- @brief Register store ready signal.
    ----------------------------------------------------------------------------
    signal register_store_ready : std_logic;

begin

    clock_input <= not clock_input after TEST_BENCH_CLOCK_PERIOD;

    stim_proc : process
    begin
        wait for TEST_BENCH_ITERATION;

        -- First test the init process. 

        if register_store_ready = '1' then
            report "Register store init test pass";
        else
            report "Register store init test fail" severity error;

            stop;
        end if;

        report "Starting reset test:";

        -- Now test the reset process 
        register_store_reset <= '1';

        -- It takes one clock cycle to transition state. 
        wait for TEST_BENCH_ITERATION;

        -- It takes two extra clock cycles to reset the register store.
        wait for TEST_BENCH_ITERATION * register_count; 

        if register_store_ready = '1' then

            -- We do not expect the register store to be in a ready state. 
            report "Register store init test fail" severity error;

            stop;

        end if;

        -- Disable the reset bit.
        register_store_reset <= '0';

        -- We need to wait for at least two iterations.
        wait for TEST_BENCH_ITERATION * 2;

        if register_store_ready = '0' then

            -- We expect the register store to be ready.
            report "Register store init test fail" severity error;

            stop;

        end if;

        for i in 0 to (register_count - 1) loop 

            register_store_index <= to_unsigned (i, register_count_bit);

            if not (to_integer(register_store_value_out) = 0) then

                report "Register reset test fail." severity error;

                stop;

            end if;

            wait for TEST_BENCH_ITERATION;

        end loop;

        report "Register zero test pass.";

        -- Wait for one iteration before next test. 
        wait for TEST_BENCH_ITERATION;

        report "Starting register write test.";

        register_store_write_enabled <= '1';

        for i in 0 to (register_count - 1) loop 

            register_store_write_value <= to_unsigned(i, register_width);
            register_store_index <= to_unsigned(i, register_count_bit);

            wait for TEST_BENCH_ITERATION;

        end loop;

        wait for TEST_BENCH_ITERATION;

        register_store_write_enabled <= '0';

        for i in 0 to (register_count - 1) loop 

            register_store_index <= to_unsigned (i, register_count_bit);

            wait for TEST_BENCH_ITERATION;

            if not (to_integer(register_store_value_out) = i) then

                report "Register write-read test fail." severity error;

                stop;

            end if;

        end loop;

        report "Register write-read test pass.";
    
        stop;
    end process;

    register_store_test : entity work.register_store
    generic map (

        -- 32 bit registers
        register_width_bit => register_width_bit,

        -- 8 registers
        register_count_bit => register_count_bit
    )

    port map (
        clock_input => clock_input,
        reset => register_store_reset,

        write_enable => register_store_write_enabled,
        write_value => register_store_write_value,
        index => register_store_index,

        ready => register_store_ready,-
        value_out => register_store_value_out
    );

end architecture;
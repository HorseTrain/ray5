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

    signal register_store_bus : register_store_type.register_store_bus_t := register_store_type.new_register_store_bus_t;

begin

    clock_input <= not clock_input after TEST_BENCH_CLOCK_PERIOD;

    stim_proc : process
    begin

        ------------------------------------------------------------------------
        -- Register store initialization test. 
        --
        -- This tests ensures after one clock cycle, the register store will 
        -- signal its ready for use.
        ------------------------------------------------------------------------

        -- Allow one clock iteration to pass.
        wait for TEST_BENCH_ITERATION;

        -- Terminate tests if the register store has not properly initialized. 
        if register_store_bus.outputs.ready = '1' then
            report "Register store initialization pass.";
        else 
            report "Register store initialization failed." severity error;
            stop;
        end if;

        -- Allow one clock iteration to pass before the next test. 
        wait for TEST_BENCH_ITERATION;

        ------------------------------------------------------------------------
        -- Register store reset test. 
        --
        -- This test ensures the reset input functions as intended.
        ------------------------------------------------------------------------

        -- We first must set the reset pin to high.
        register_store_bus.inputs.reset <= '1';

        -- We must allow at least one clock cycle to pass to allow the register 
        -- store to switch into its reset state. 
        wait for TEST_BENCH_ITERATION;

        -- A full reset of the register store takes 
        -- (register_count * TEST_BENCH_ITERATION) clock iterations.
        for i in 0 to (register_store_type.register_count - 1) loop

            -- When the register store is resetting, it may not be used, so we 
            -- need to ensure the ready bit is low.
            if register_store_bus.outputs.ready = '1' then 
                report "Register store reset failed." severity error;
                stop;
            end if;

            wait for TEST_BENCH_ITERATION;

        end loop;

        -- Wait for at least one clock cycle so the register store may advance 
        -- its internal state.
        wait for TEST_BENCH_ITERATION;

        -- At this point, the reset pin is still high. The register store may 
        -- not transition into a usable state until the reset pin is low.
        if register_store_bus.outputs.ready = '1' then
            report "Register store reset failed." severity error;
            stop;
        end if;

        -- Wait one clock iteration.
        wait for TEST_BENCH_ITERATION;

        -- Now we may set the reset pin low.
        register_store_bus.inputs.reset <= '0';

        -- Wait another clock iteration.
        wait for TEST_BENCH_ITERATION;

        -- The register store should be ready for further use.
        if register_store_bus.outputs.ready = '0' then
            report "Register store reset failed." severity error;
            stop;
        end if;

        -- Now we must test every value in the register store, and ensure its 
        -- zero.

        report "Register store test complete!";

        stop;

    end process;

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
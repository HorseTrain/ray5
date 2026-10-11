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
use work.core_p.all;
use work.ray5_globals_p.all;

entity test_core is 
end entity;

architecture tb of test_core is 

    ----------------------------------------------------------------------------
    -- @brief Clock input.
    ----------------------------------------------------------------------------
    signal clock_input : std_logic := '0';

    ----------------------------------------------------------------------------
    -- @brief Bus for main core. 
    ----------------------------------------------------------------------------
    signal core_bus : core_bus_t;

begin

    clock_input <= not clock_input after TEST_BENCH_CLOCK_PERIOD_HALF;

    stim_proc : process 

        ------------------------------------------------------------------------
        -- @brief Amount of clock periods to elapse for initialization.
        ------------------------------------------------------------------------
        variable initialize_periods_elapsed : integer := 0;

    begin
        ------------------------------------------------------------------------
        -- Core initialization test.
        --
        -- This test ensures the core will report an initialized state (eventually lol)
        ------------------------------------------------------------------------

        wait_for_init : loop 

            if core_bus.outputs.core_status_out = CORE_STATUS_OUT_IDLE then
                exit wait_for_init;
            end if;

            -- This is preferred between `await for` to ensure time never drifts 
            -- from multiples of `TEST_BENCH_CLOCK_PERIOD`
            wait for TEST_BENCH_CLOCK_PERIOD;

            if initialize_periods_elapsed >= 1024 then
                -- If 1024 clock periods pass, and the core is not initialized, then 
                -- something is wrong.

                report "Core initialization test fail."
                severity error;

                stop;
            end if;

            initialize_periods_elapsed := initialize_periods_elapsed + 1;

        end loop;

        report "Core initialized.";

        ------------------------------------------------------------------------
        -- Program counter set test. 
        --
        -- The program counter of a core may be set from the outside with an 
        -- interrupt.
        ------------------------------------------------------------------------
        core_bus.inputs.set_program_counter <= '1';
        core_bus.inputs.new_program_counter <= register_store_type.to_register_value(1024);

        wait for TEST_BENCH_CLOCK_PERIOD * 2;

        report "Core test success!";
        
        stop;

    end process;

    -- Route the clock input into the core. 
    core_bus.inputs.clock_input <= clock_input;

    core : entity work.core 
    port map (
        inputs => core_bus.inputs,
        outputs => core_bus.outputs
    );

end architecture;
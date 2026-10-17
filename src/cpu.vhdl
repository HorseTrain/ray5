--------------------------------------------------------------------------------
-- Copyright (c) 2026 Mataka Studio. All rights reserved.
-- 
-- @brief CPU.
-- 
-- @description 
--      Top level ray5 cpu entity.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.core_p.all;

entity cpu is 

    port (

        ------------------------------------------------------------------------
        -- @brief Main clock signal that drives the entire cpu.
        ------------------------------------------------------------------------
        CLK100MHZ : in std_logic;

        ------------------------------------------------------------------------
        -- @brief Red heartbeat LED.
        ------------------------------------------------------------------------
        led0_r : out std_logic
    );

end entity;

architecture rtl of cpu is 

    ----------------------------------------------------------------------------
    -- @brief Main clock.
    ----------------------------------------------------------------------------
    signal clock_input : std_logic;

    ----------------------------------------------------------------------------
    -- @brief The amount of core in a CPU. 
    ----------------------------------------------------------------------------
    constant core_count : integer := 8;

    ----------------------------------------------------------------------------
    -- @brief Collection of core busses definition.
    ----------------------------------------------------------------------------
    type core_bus_collection_t is array (0 to (core_count - 1)) of core_bus_t;

    ----------------------------------------------------------------------------
    -- @brief Collection of cure busses. 
    ----------------------------------------------------------------------------
    signal core_bus_collection : core_bus_collection_t;

    ----------------------------------------------------------------------------
    -- @brief LED test counter.
    ----------------------------------------------------------------------------
    signal led_test : unsigned (0 to 31) := (others => '0');

    ----------------------------------------------------------------------------
    -- @brief Definition of CPU states. 
    ----------------------------------------------------------------------------
    type cpu_state_t is (

        -- Cpu is initializing all components.
        CPU_STATE_INITIALIZING,

        -- Cpu is initializing core 0 to begin execution.
        CPU_STATE_INITIALIZE_CORE_0,

        -- Cpu is in an error state, and needs a restart. 
        CPU_STATE_ERROR
    );

    ----------------------------------------------------------------------------
    -- @brief Current cpu state. 
    ----------------------------------------------------------------------------
    signal cpu_state : cpu_state_t := CPU_STATE_INITIALIZING;

    ----------------------------------------------------------------------------
    -- @brief Core initialization signals.
    ----------------------------------------------------------------------------

    -- Loop index for ready check.
    signal cores_ready_check_idx : integer range 0 to (core_count + 1) := 0;

    -- All ready check.
    signal cores_ready_check : std_logic := '0';

begin

    ----------------------------------------------------------------------------
    -- For now, clock_input will be aliased with `CLK100MHZ`.
    ----------------------------------------------------------------------------
    clock_input <= CLK100MHZ;

    ----------------------------------------------------------------------------
    -- Instantiate our cores. 
    ----------------------------------------------------------------------------
    cores : for i in 0 to (core_count - 1) generate
    begin

        core_i : entity work.core 
        port map (
            inputs => core_bus_collection(i).inputs,
            outputs => core_bus_collection(i).outputs
        );

        -- Route clock clock into cores. 
        core_bus_collection(i).inputs.clock_input <= clock_input;

    end generate;

    process (clock_input) is
    begin 

        if rising_edge(clock_input) then

            -- Oscillate red LED. 
            led_test <= led_test + 1;

            case cpu_state is 

                when CPU_STATE_INITIALIZING => 

                    -- Pulse the LED to signal the cpu is initializing.
                    led0_r <= led_test(5);

                    -- Increment the check index. 
                    cores_ready_check_idx <= cores_ready_check_idx + 1;

                    if cores_ready_check_idx < core_count then

                        -- If the core being checked 
                        if not (core_bus_collection(cores_ready_check_idx).outputs.core_status_out = CORE_STATUS_OUT_IDLE) then
                            
                            -- If the core is not ready, set the signal low. 
                            cores_ready_check <= '0';                    
                        end if;

                    end if;

                    -- If the core check hits the end reset. 
                    if cores_ready_check_idx = core_count then

                        -- If all the cores are idle, transition to initializing 
                        -- core zero to begin execution.
                        if cores_ready_check = '1' then

                            cpu_state <= CPU_STATE_INITIALIZE_CORE_0;

                        else

                            cores_ready_check_idx <= 0;
                            cores_ready_check <= '1';

                        end if;

                    end if;          
                    
                when CPU_STATE_INITIALIZE_CORE_0 => 

                    -- Set the core0 entry point.


                when others => 

                    -- Processor is hung up, and requires a restart. 
                    led0_r <= '1';

                    null;

            end case ;

        end if;

    end process;

end architecture;
--------------------------------------------------------------------------------
-- Copyright (c) 2026 Mataka Studio. All rights reserved.
-- 
-- @brief Core.
-- 
-- @description 
--      A core represents a single line of execution. 
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ray5_globals_p.all;
use work.core_p.all;

entity core is

    port (
        ------------------------------------------------------------------------
        -- @brief Inputs.
        ------------------------------------------------------------------------
        inputs : in core_inputs_t;

        ------------------------------------------------------------------------
        -- @brief Outputs.
        ------------------------------------------------------------------------
        outputs : out core_outputs_t
    );

end;
        
architecture rtl of core is 
        
    ----------------------------------------------------------------------------
    -- @brief Status of this core.
    ----------------------------------------------------------------------------
    signal core_state : core_state_t := CORE_STATE_INITIALIZING;

    ----------------------------------------------------------------------------
    -- @brief Bus for main register store.
    ----------------------------------------------------------------------------
    signal register_bus : register_store_type.register_store_bus_t;

    ----------------------------------------------------------------------------
    -- @brief Register store init steps. 
    ----------------------------------------------------------------------------
    type register_store_init_state_t is (

        ------------------------------------------------------------------------
        -- Waiting for the register store to signal its ready for IO.
        -- 
        -- May take an arbitrary amount of clock cycles. 
        ------------------------------------------------------------------------
        REGISTER_STORE_NOT_READY,

        ------------------------------------------------------------------------
        -- The register store is ready for use, now we must signal it to reset. 
        -- 
        -- One clock cycle. 
        ------------------------------------------------------------------------
        REGISTER_STORE_SET_RESET,

        ------------------------------------------------------------------------
        -- The register store is resetting, now we must wait for it to signal 
        -- its ready for IO.
        --
        -- May take an arbitrary amount of clock cycles. 
        ------------------------------------------------------------------------
        REGISTER_STORE_RESETTING,

        ------------------------------------------------------------------------
        -- This init state is complete. 
        ------------------------------------------------------------------------
        REGISTER_STORE_READY
    );

    ----------------------------------------------------------------------------
    -- @brief Register store init state. 
    --
    -- @see `register_store_init_state_t`
    ----------------------------------------------------------------------------
    signal register_store_init_state : register_store_init_state_t := REGISTER_STORE_NOT_READY;

    ----------------------------------------------------------------------------
    -- @brief Program counter cache.
    ----------------------------------------------------------------------------
    signal new_program_counter_cache : register_store_type.register_t;

begin    

    -- Feed the clock input to the register store.
    register_bus.inputs.clock_input <= inputs.clock_input;

    -- Instance of the general purpose register store.
    general_purpose_registers : entity work.register_store
    generic map (
        register_store_pkg => register_store_type
    )
    port map (
        inputs => register_bus.inputs,
        outputs => register_bus.outputs
    );

    -- Main clocked process for core.
    process (inputs.clock_input) 
    begin

        if rising_edge(inputs.clock_input) then

            -- Main state machine of this core.
            case core_state is 

                when CORE_STATE_INITIALIZING => 

                    -- Signal to the outside world this core is not ready.
                    outputs.core_status_out <= CORE_STATUS_OUT_INIT_STATE;

                    ------------------------------------------------------------
                    -- Signal to components to begin their initialization process. 
                    ------------------------------------------------------------
                    case register_store_init_state is 
                        when REGISTER_STORE_NOT_READY => 

                            -- Wait for the register store to signal its ready 
                            -- before transitioning to next state. 
                            if register_bus.outputs.ready then 
                                register_store_init_state <= REGISTER_STORE_SET_RESET;
                            end if;

                            -- Set initial state for the register store. 
                            register_bus.inputs.write_enable <= '0';
                            register_bus.inputs.index <= (others => '0');
                            register_bus.inputs.write_value <= (others => '0');

                        when REGISTER_STORE_SET_RESET => 

                            -- Set the register store reset pin high.

                            -- This may be done in the previous state?
                            register_bus.inputs.reset <= '1';

                            register_store_init_state <= REGISTER_STORE_RESETTING;

                        when REGISTER_STORE_RESETTING => 

                            -- Keep reset pin low.
                            register_bus.inputs.reset <= '0';

                            -- Once the register store is ready, its initialization is complete. 
                            if register_bus.outputs.ready then 
                                register_store_init_state <= REGISTER_STORE_READY;
                            end if;

                        when REGISTER_STORE_READY => 

                            -- Do nothing here. 
                            null;

                        when others => 
                            
                            -- Should never happen.
                            core_state <= CORE_STATE_ERROR;

                    end case;

                    -- Transition to fetching instructions.
                    if register_store_init_state = REGISTER_STORE_READY then
                        core_state <= CORE_STATE_IDLE;
                    end if;

                when CORE_STATE_IDLE => 

                    -- Core is in an idle state. 
                    outputs.core_status_out <= CORE_STATUS_OUT_IDLE;

                    if inputs.set_program_counter = '1' then
                        -- The core is in a blocked state. 
                        outputs.core_status_out <= CORE_STATUS_OUT_BLOCKED;

                        -- Cache the input program counter.
                        new_program_counter_cache <= inputs.new_program_counter;

                        -- Enter set program counter state. 
                        core_state <= CORE_STATE_SET_PROGRAM_COUNTER;

                    end if;
                    
                when CORE_STATE_SET_PROGRAM_COUNTER => 

                    -- Signal the register bus to enable writes. 
                    register_bus.inputs.write_enable <= '1';
                    
                    -- Set the register bus index to the program counter. 
                    register_bus.inputs.index <= PROGRAM_COUNTER_INDEX;
                    register_bus.inputs.write_value <= new_program_counter_cache;

                    -- The register store will write our new program counter 
                    -- on the next clock cycle, so we can return back to an idle
                    -- state. 
                    core_state <= CORE_STATE_IDLE;

                when others => 

                    -- Undefined core state, consider this an unrecoverable error.
                    outputs.core_status_out <= CORE_STATUS_OUT_UNRECOVERABLE_FAILURE;

            end case;
        end if;

    end process;

end architecture;
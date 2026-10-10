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
        -- Inputs.
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- @brief Clock input.
        ------------------------------------------------------------------------
        clock_input : in std_logic; 

        ------------------------------------------------------------------------
        -- Outputs.
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- @brief Core status.
        ------------------------------------------------------------------------
        core_status_out : out unsigned (0 to 2) := (others => '0')
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
    signal gp_register_bus : register_store_type.register_store_bus_t;

begin

    -- Temporary (Will be removed.)
    gp_register_bus.inputs.write_enable <= '0';
    gp_register_bus.inputs.index <= (others => '0');
    gp_register_bus.inputs.reset <= '0';

    -- Feed the clock input to the register store.
    gp_register_bus.inputs.clock_input <= clock_input;

    -- Instance of the general purpose register store.
    general_purpose_registers : entity work.register_store
    generic map (
        register_store_pkg => register_store_type
    )
    port map (
        inputs => gp_register_bus.inputs,
        outputs => gp_register_bus.outputs
    );

    -- Main clocked process for core.
    process (clock_input) 
    begin

        if rising_edge(clock_input) then

            -- Main state machine of this core.
            case core_state is 

                when CORE_STATE_INITIALIZING => 

                    -- Signal to the outside world this core is not ready.
                    core_status_out <= CORE_STATUS_OUT_INIT_STATE;

                    -- Currently the only check to move on.
                    if gp_register_bus.outputs.ready then

                        -- Core is ready, begin fetching instructions.
                        core_state <= CORE_STATE_FETCH;
                    end if;

                when CORE_STATE_FETCH => 

                    -- Signal to the outside world this core is executing.
                    core_status_out <= CORE_STATUS_OUT_UNBLOCKED;

                    

                when others => 

                    -- Undefined core state, consider this an unrecoverable error.
                    core_status_out <= "100";

            end case;


        end if;

    end process;

end architecture;
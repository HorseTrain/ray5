--------------------------------------------------------------------------------
-- Copyright (c) 2026 Mataka Studio. All rights reserved.
-- 
-- @brief Package for structures used in Core.  
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

package core_p is 

    ----------------------------------------------------------------------------
    -- @brief Output status type.
    ----------------------------------------------------------------------------
    subtype core_status_out_t is unsigned(0 to 2);

    ----------------------------------------------------------------------------
    -- @brief Amount of bits a core state needs. 
    ----------------------------------------------------------------------------
    subtype core_state_t is unsigned(0 to 4);

    -- Unrecoverable failure.
    constant CORE_STATUS_OUT_UNRECOVERABLE_FAILURE : core_status_out_t := "100"; 

    -- Core is currently initializing all of its systems.
    constant CORE_STATUS_OUT_INIT_STATE : core_status_out_t := "000";
    
    -- Core is executing, and currently not waiting on anything.
    constant CORE_STATUS_OUT_UNBLOCKED : core_status_out_t := "001";

    -- Core is currently waiting on something.
    constant CORE_STATUS_OUT_BLOCKED : core_status_out_t := "010";

    ----------------------------------------------------------------------------
    -- States for core state machine.
    ----------------------------------------------------------------------------
    
    -- Core is currently initializing all of its systems.
    constant CORE_STATE_INITIALIZING : core_state_t := "00000";

    -- Core is fetching an instruction from memory, and storing it to its local 
    -- instruction cache.
    constant CORE_STATE_FETCH : core_state_t := "00001";

    -- Core is decoding the instruction in its cache.
    constant CORE_STATE_DECODE : core_state_t := "00010";

    -- Core is executing the instruction in its cache.
    constant CORE_STATE_EXECUTE : core_state_t := "00011";

    ----------------------------------------------------------------------------
    -- @brief Inputs of a core bus.
    ----------------------------------------------------------------------------
    type core_inputs is record 

        ------------------------------------------------------------------------
        -- @brief Clock input for core.
        ------------------------------------------------------------------------
        clock_input : std_logic;

    end record;

    ----------------------------------------------------------------------------
    -- @brief Outputs of a core bus.
    ----------------------------------------------------------------------------
    type core_outputs is record 

        ------------------------------------------------------------------------
        -- @brief Core status.
        ------------------------------------------------------------------------
        core_status_out : core_status_out_t;

    end record core_outputs;

    type core_bus is record 

        ------------------------------------------------------------------------
        -- @brief Inputs of a core bus.
        ------------------------------------------------------------------------
        inputs : core_inputs;

        ------------------------------------------------------------------------
        -- @brief Inputs of a core bus.
        ------------------------------------------------------------------------
        outputs : core_outputs;

    end record core_bus;

end core_p;
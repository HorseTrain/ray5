--------------------------------------------------------------------------------
-- Copyright (c) 2026 Mataka Studio. All rights reserved.
-- 
-- @brief Package for structures used in Core.  
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.ray5_globals_p.all;

package core_p is 

    ----------------------------------------------------------------------------
    -- @brief Output status type.
    ----------------------------------------------------------------------------
    type core_status_out_t is (

        -- Unrecoverable failure.
        CORE_STATUS_OUT_UNRECOVERABLE_FAILURE,

        -- Core is currently initializing all of its systems.
        CORE_STATUS_OUT_INIT_STATE, 

        -- Core is idle, and waiting for commands.
        CORE_STATUS_OUT_IDLE,

        -- Core is executing, and currently not waiting on anything.
        CORE_STATUS_OUT_UNBLOCKED,

        -- Core is currently waiting on something.
        CORE_STATUS_OUT_BLOCKED
    );

    ----------------------------------------------------------------------------
    -- @brief States for core state machine.
    ----------------------------------------------------------------------------
    type core_state_t is (
        -- Core is currently initializing all of its systems.
        CORE_STATE_INITIALIZING,

        -- Core is idle, and waiting for instruction.
        CORE_STATE_IDLE,

        -- Core is fetching an instruction from memory, and storing it to its local 
        -- instruction cache.
        CORE_STATE_FETCH,

        -- Core is decoding the instruction in its cache.
        CORE_STATE_DECODE,

        -- Core is executing the instruction in its cache.
        CORE_STATE_EXECUTE,

        -- Core is about to set the program counter. 
        CORE_STATE_SET_PROGRAM_COUNTER,

        -- Error core state. 
        CORE_STATE_ERROR
    );

    ----------------------------------------------------------------------------
    -- @brief Interrupts table for core.
    ----------------------------------------------------------------------------
    type core_interrupt_t is (
        CORE_INTERRUPT_PROGRAM_COUNTER_SET,

        CORE_INTERRUPT_END
    );
    
    ----------------------------------------------------------------------------
    -- @brief System registers. 
    ----------------------------------------------------------------------------

    -- Program counter index. 
    constant PROGRAM_COUNTER_INDEX : register_store_type.register_index_t := register_store_type.to_register_index(8);

    ----------------------------------------------------------------------------
    -- @brief Inputs of a core bus.
    ----------------------------------------------------------------------------
    type core_inputs_t is record 

        ------------------------------------------------------------------------
        -- @brief Clock input for core.
        ------------------------------------------------------------------------
        clock_input : std_logic;

        ------------------------------------------------------------------------
        -- @brief Set pc pin.
        --
        -- @description 
        --      If high, and the core is in an idling state, 
        --      `new_program_counter` will be written into the program counter. 
        --      
        --      If high and the core is not idling, the core may be placed in 
        --      an unrecoverable state. 
        ------------------------------------------------------------------------
        set_program_counter : std_logic;

        ------------------------------------------------------------------------
        -- @brief New program counter.
        -- 
        -- @see `set_program_counter`
        --
        -- @note 
        --      I am skeptical of having a wire this wide as an input, consider 
        --      making this a serial interface in the future (this is fine for
        --      now).
        ------------------------------------------------------------------------
        new_program_counter : register_store_type.register_t;        

    end record;

    ----------------------------------------------------------------------------
    -- @brief Outputs of a core bus.
    ----------------------------------------------------------------------------
    type core_outputs_t is record 

        ------------------------------------------------------------------------
        -- @brief Core status.
        ------------------------------------------------------------------------
        core_status_out : core_status_out_t;

    end record;

    type core_bus_t is record 

        ------------------------------------------------------------------------
        -- @brief Inputs of a core bus.
        ------------------------------------------------------------------------
        inputs : core_inputs_t;

        ------------------------------------------------------------------------
        -- @brief Inputs of a core bus.
        ------------------------------------------------------------------------
        outputs : core_outputs_t;

    end record;

end core_p;
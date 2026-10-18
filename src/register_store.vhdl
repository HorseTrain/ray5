--------------------------------------------------------------------------------
-- Copyright (c) 2026 Mataka Studio. All rights reserved.
-- 
-- @brief Register store.
-- 
-- @description 
--      Stores a collection of registers.
--
-- @note 
--      It is important to define `ready` and `write_enabled` or else the 
--      register store may not properly initiate. 
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity register_store is 

    generic (
        package register_store_pkg is new work.register_store_type_p generic map (<>)
    );

    port (

        ------------------------------------------------------------------------
        -- @brief Register store inputs. 
        --
        -- @see 
        --      register_store_pkg.register_store_inputs_t
        ------------------------------------------------------------------------
        inputs : in register_store_pkg.register_store_inputs_t;

        ------------------------------------------------------------------------
        -- @brief Register store inputs. 
        --
        -- @see 
        --      register_store_pkg.register_store_outputs_t
        ------------------------------------------------------------------------
        outputs : out register_store_pkg.register_store_outputs_t
    );

end entity;

architecture rtl of register_store is 

    ----------------------------------------------------------------------------
    -- Register store state machine values.
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- @brief Type of state machine names.
    ----------------------------------------------------------------------------
    type state_name_t is (
        ------------------------------------------------------------------------
        -- @brief Unready state.
        --
        -- @description 
        --      Register store is not ready for use.
        ------------------------------------------------------------------------
        STATE_NOT_READY,

        ------------------------------------------------------------------------
        -- @brief Normal state.
        --
        -- @description 
        --      Register store is accepting inputs, and sending outputs.
        ------------------------------------------------------------------------
        STATE_ACCEPT_IO,

        ------------------------------------------------------------------------
        -- @brief Reset state.
        --
        -- @description 
        --      Register store is not accepting inputs, nor sending outputs, but 
        --      instead resetting all internal state. 
        ------------------------------------------------------------------------
        STATE_RESTART,

        ------------------------------------------------------------------------
        -- @brief Waiting period for restart. 
        --
        -- @description 
        --      After the register store has completed restarting, we must wait 
        --      for the reset pin to go low before continuing.
        ------------------------------------------------------------------------
        STATE_RESTART_WAIT
    );

    ----------------------------------------------------------------------------
    -- @brief Type of register index. 
    ----------------------------------------------------------------------------
    subtype register_index_t is unsigned (0 to (register_store_pkg.register_count_bit - 1));

    ----------------------------------------------------------------------------
    -- @brief Current state of register store.
    ----------------------------------------------------------------------------
    signal state : state_name_t := STATE_NOT_READY;

    ----------------------------------------------------------------------------
    -- @brief Register store.
    --
    -- @note 
    --      To keep silicon usage small, these are reset through a clocked 
    --      iterator.
    ----------------------------------------------------------------------------
    signal register_collection : register_store_pkg.register_collection_t;

    ----------------------------------------------------------------------------
    -- State for reset logic.
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- @brief Current reset index.
    ----------------------------------------------------------------------------
    signal reset_idx : register_index_t;

begin

    ----------------------------------------------------------------------------
    -- Output the ready state of this register store.
    ----------------------------------------------------------------------------
    outputs.ready <= '1' when (state = STATE_ACCEPT_IO) else '0';

    ----------------------------------------------------------------------------
    -- Value being sent out.
    ----------------------------------------------------------------------------
    outputs.value_out <= register_collection(to_integer(inputs.index));

    process (inputs.clock_input) 
    begin
        if rising_edge(inputs.clock_input) then

            -- TODO: Turn this to a case. 
            if state = STATE_NOT_READY then

                -- Have the register store not ready for one clock cycle.
                state <= STATE_ACCEPT_IO;

            elsif state = STATE_ACCEPT_IO then

                if inputs.reset = '1' then

                    -- Begin reset procedure if reset pin is high.
                    state <= STATE_RESTART;
                    reset_idx <= (others => '0');

                elsif inputs.write_enable = '1' then

                    -- Store the input.
                    register_collection( to_integer(inputs.index) ) <= inputs.write_value;
                end if;

            -- Reset logic 
            elsif state = STATE_RESTART then

                register_collection(to_integer(reset_idx)) <= (others => '0');
                reset_idx <= reset_idx + to_unsigned(1, register_store_pkg.register_count_bit);

                if reset_idx = (to_unsigned(register_store_pkg.register_count - 1, register_store_pkg.register_count_bit)) then
                    state <= STATE_RESTART_WAIT;
                end if;

            elsif state = STATE_RESTART_WAIT then 

                if inputs.reset = '0' then
                    -- We do not want to enter a normal state if the reset pin 
                    -- is high.
                    state <= STATE_ACCEPT_IO;
                end if; 

            end if;
        end if;
    end process;

end architecture;
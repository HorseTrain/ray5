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
    subtype state_name_t is unsigned (0 to 2);

    ----------------------------------------------------------------------------
    -- @brief Type of register index. 
    ----------------------------------------------------------------------------
    subtype register_index_t is unsigned (0 to (register_store_pkg.register_count_bit - 1));

    ----------------------------------------------------------------------------
    -- @brief Unready state.
    --
    -- @description 
    --      Register store is not ready for use.
    ----------------------------------------------------------------------------
    constant STATE_NOT_READY : state_name_t := "000";

    ----------------------------------------------------------------------------
    -- @brief Normal state.
    --
    -- @description 
    --      Register store is accepting inputs, and sending outputs.
    ----------------------------------------------------------------------------
    constant STATE_ACCEPT_IO : state_name_t := "001";

    ----------------------------------------------------------------------------
    -- @brief Reset state.
    --
    -- @description 
    --      Register store is not accepting inputs, nor sending outputs, but 
    --      instead resetting all internal state. 
    ----------------------------------------------------------------------------
    constant STATE_RESTART : state_name_t := "010";

    ----------------------------------------------------------------------------
    -- @brief Current state of register store.
    ----------------------------------------------------------------------------
    signal state : state_name_t := STATE_NOT_READY;

    ----------------------------------------------------------------------------
    -- @brief Register store type.
    ----------------------------------------------------------------------------
    type register_store_t is array (0 to (register_store_pkg.register_count - 1)) of unsigned (0 to (register_store_pkg.register_width - 1));

    ----------------------------------------------------------------------------
    -- @brief Register store.
    --
    -- @note 
    --      To keep silicon usage small, these are reset through a clocked 
    --      iterator.
    ----------------------------------------------------------------------------
    signal register_store : register_store_t;

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
    outputs.value_out <= register_store(to_integer(inputs.index));

    process (inputs.clock_input) 
    begin
        if rising_edge(inputs.clock_input) then

            if state = STATE_NOT_READY then

                -- Have the register store not ready for one clock cycle.

                if inputs.reset = '0' then
                    -- We do not want to enter a normal state if the reset pin 
                    -- is high.
                    state <= STATE_ACCEPT_IO;
                end if; 

            elsif state = STATE_ACCEPT_IO then

                if inputs.reset = '1' then

                    -- Begin reset procedure if reset pin is high.
                    state <= STATE_RESTART;
                    reset_idx <= (others => '0');

                elsif inputs.write_enable = '1' then

                    -- Store the input.
                    register_store( to_integer(inputs.index) ) <= inputs.write_value;
                end if;

            -- Reset logic 
            elsif state = STATE_RESTART then

                register_store(to_integer(reset_idx)) <= (others => '0');
                reset_idx <= reset_idx + to_unsigned(1, register_store_pkg.register_count_bit);

                if reset_idx = (to_unsigned(register_store_pkg.register_count - 1, register_store_pkg.register_count_bit)) then
                    state <= STATE_NOT_READY;
                end if;

            end if;
        end if;
    end process;

end architecture;
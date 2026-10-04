--------------------------------------------------------------------------------
-- Copyright (c) 2026 Mataka Studio. All rights reserved.
-- 
-- @brief Register store.
-- 
-- @description 
--      Stores a collection of registers.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_store is 

    generic (
        ------------------------------------------------------------------------
        -- @brief Width of general purpose registers.
        -- 
        -- @note Represented as log2(register_count) for internal indexing ease.
        --       For example, 5 bits = 2^5 = 32.
        ------------------------------------------------------------------------
        register_width_bit : integer := 3;

        ------------------------------------------------------------------------
        -- @brief Number of general-purpose registers (as address bit-width).
        -- 
        -- @note Represented as log2(register_count) for internal indexing ease.
        --       For example, 3 bits = 2^3 = 8 registers.
        ------------------------------------------------------------------------
        register_count_bit : integer := 5
    );

    port (

        ------------------------------------------------------------------------
        -- Inputs.
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- @brief Clock input.
        ------------------------------------------------------------------------
        clock_input : in std_logic;

        ------------------------------------------------------------------------
        -- @brief Reset pin.
        -- 
        -- @note 
        --      If high, this register store will neither accept, nor or output 
        --      values.
        ------------------------------------------------------------------------
        reset : in std_logic := '0';

        ------------------------------------------------------------------------
        -- @brief Write enable.
        --
        -- @description 
        --      When high, and on a rising clock edge, `write_value` will be 
        --      written into the register with index `index`.
        ------------------------------------------------------------------------
        write_enable : in std_logic;

        ------------------------------------------------------------------------
        -- @brief Value to be written into register store.
        --
        -- @description
        --      When on a rising clock edge, and `write_enable` is high, this 
        --      value will be written into the register with index 
        --      `index`.
        ------------------------------------------------------------------------
        write_value : in unsigned (0 to ((2 ** register_width_bit) - 1));

        ------------------------------------------------------------------------
        -- @brief Register index.
        --
        -- @description
        --      Index of the register store is working with.
        ------------------------------------------------------------------------
        index : in unsigned (0 to (register_count_bit - 1));

        ------------------------------------------------------------------------
        -- Outputs.
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- @brief Value going out of register store.
        ------------------------------------------------------------------------
        value_out : out unsigned (0 to ((2 ** register_width_bit) - 1));

        ------------------------------------------------------------------------
        -- @brief Ready pin.
        --
        -- @note 
        --      High -> Register store is ready.
        --      Low -> Register store is not ready.
        ------------------------------------------------------------------------
        ready : out std_logic
    );

end entity;

architecture rtl of register_store is 

    ----------------------------------------------------------------------------
    -- @brief Width of general purpose registers.
    ----------------------------------------------------------------------------
    constant register_width : integer := 2** register_width_bit;

    ----------------------------------------------------------------------------
    -- @brief Number of general purpose registers.
    ----------------------------------------------------------------------------
    constant register_count : integer := 2** register_count_bit;    

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
    subtype register_index_t is unsigned (0 to (register_count_bit - 1));

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
    type register_store_t is array (0 to (register_count - 1)) of unsigned (0 to (register_width - 1));

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
    ready <= '1' when (state = STATE_ACCEPT_IO) else '0';

    ----------------------------------------------------------------------------
    -- Value being sent out.
    ----------------------------------------------------------------------------
    value_out <= register_store(to_integer(index));

    process (clock_input) 
    begin
        if rising_edge(clock_input) then

            if state = STATE_NOT_READY then

                -- Have the register store not ready for one clock cycle.

                if reset = '0' then
                    -- We do not want to enter a normal state if the reset pin 
                    -- is high.
                    state <= STATE_ACCEPT_IO;
                end if; 

            elsif state = STATE_ACCEPT_IO then

                if reset = '1' then

                    -- Begin reset procedure if reset pin is high.
                    state <= STATE_RESTART;
                    reset_idx <= (others => '0');

                elsif write_enable = '1' then

                    -- Store the input.
                    register_store( to_integer(index) ) <= write_value;
                end if;

            -- Reset logic 
            elsif state = STATE_RESTART then

                register_store(to_integer(reset_idx)) <= (others => '0');
                reset_idx <= reset_idx + "001";

                if reset_idx = (to_unsigned(register_count - 1, 3)) then
                    state <= STATE_NOT_READY;
                end if;

            end if;
        end if;
    end process;

end architecture;
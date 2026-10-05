--------------------------------------------------------------------------------
-- Copyright (c) 2026 Mataka Studio. All rights reserved.
-- 
-- @brief Register store.
-- 
-- @description 
--      Stores a collection of registers.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package register_store_type_p is 

    generic (
        ------------------------------------------------------------------------
        -- @brief Width of general purpose registers.
        -- 
        -- @note Represented as log2(register_count) for internal indexing ease.
        --       For example, 5 bits = 2^5 = 32.
        ------------------------------------------------------------------------
        register_width_bit : integer;

        ------------------------------------------------------------------------
        -- @brief Number of general-purpose registers (as address bit-width).
        -- 
        -- @note Represented as log2(register_count) for internal indexing ease.
        --       For example, 3 bits = 2^3 = 8 registers.
        ------------------------------------------------------------------------
        register_count_bit : integer
    );

    ----------------------------------------------------------------------------
    -- @brief Width of general purpose registers.
    ----------------------------------------------------------------------------
    constant register_width : integer := (2 ** register_width_bit);

    ----------------------------------------------------------------------------
    -- @brief Number of general purpose registers.
    ----------------------------------------------------------------------------
    constant register_count : integer := (2 ** register_count_bit);

    type register_store_inputs_t is record 

        ------------------------------------------------------------------------
        -- @brief Clock input.
        ------------------------------------------------------------------------
        clock_input : std_logic;

        ------------------------------------------------------------------------
        -- @brief Reset pin.
        -- 
        -- @note 
        --      If high, this register store will neither accept, nor or output 
        --      values.
        ------------------------------------------------------------------------
        reset : std_logic;

        ------------------------------------------------------------------------
        -- @brief Write enable.
        --
        -- @description 
        --      When high, and on a rising clock edge, `write_value` will be 
        --      written into the register with index `index`.
        ------------------------------------------------------------------------
        write_enable : std_logic;

        ------------------------------------------------------------------------
        -- @brief Value to be written into register store.
        --
        -- @description
        --      When on a rising clock edge, and `write_enable` is high, this 
        --      value will be written into the register with index 
        --      `index`.
        ------------------------------------------------------------------------
        write_value : unsigned (0 to (register_width - 1));

        ------------------------------------------------------------------------
        -- @brief Register index.
        --
        -- @description
        --      Index of the register store is working with.
        ------------------------------------------------------------------------
        index : unsigned (0 to (register_count_bit - 1));

    end record register_store_inputs_t;

    type register_store_outputs_t is record 

        ------------------------------------------------------------------------
        -- @brief Value going out of register store.
        ------------------------------------------------------------------------
        value_out : unsigned (0 to (register_width - 1));

        ------------------------------------------------------------------------
        -- @brief Ready pin.
        --
        -- @note 
        --      High -> Register store is ready.
        --      Low -> Register store is not ready.
        ------------------------------------------------------------------------
        ready : std_logic;

    end record register_store_outputs_t;

    type register_store_bus_t is record 

        ------------------------------------------------------------------------
        -- @brief Inputs.
        ------------------------------------------------------------------------
        inputs : register_store_inputs_t;

        ------------------------------------------------------------------------
        -- @brief Outputs.
        ------------------------------------------------------------------------
        outputs : register_store_outputs_t;

    end record register_store_bus_t;

end package;
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

package register_store_pkg is 

    type register_store_template_t is record 
        
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
        register_count_bit : integer;

        ------------------------------------------------------------------------
        -- @brief Width of general purpose registers.
        ------------------------------------------------------------------------
        register_width : integer;

        ------------------------------------------------------------------------
        -- @brief Number of general purpose registers.
        ------------------------------------------------------------------------
        register_count : integer; 

    end record register_store_template_t; 

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
        write_value : unsigned;

        ------------------------------------------------------------------------
        -- @brief Register index.
        --
        -- @description
        --      Index of the register store is working with.
        ------------------------------------------------------------------------
        index : unsigned;

    end record register_store_inputs_t;

    type register_store_outputs_t is record 

        ------------------------------------------------------------------------
        -- @brief Value going out of register store.
        ------------------------------------------------------------------------
        value_out : unsigned;

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

    ----------------------------------------------------------------------------
    -- @brief Create a register store bus from a register store template. 
    --
    -- @param [in] register_store_template - Register store template to derive 
    --                                       a bus from.
    ----------------------------------------------------------------------------
    function create_register_store_bus_t (
        register_store_template : register_store_template_t        
    ) return register_store_bus_t;

    ----------------------------------------------------------------------------
    -- @brief Create a register data type.
    --
    -- @param [in] register_width_bit - Log2 of register width.
    -- @param [in] register_count_bit - Log2 of register count.
    ----------------------------------------------------------------------------
    function new_register_store_template_t (
        register_width_bit : integer; 
        register_count_bit : integer
    ) return register_store_template_t;

    ----------------------------------------------------------------------------
    -- @brief Create a register store bus.
    --
    -- @param [in] register_width_bit - Log2 of register width.
    -- @param [in] register_count_bit - Log2 of register count.
    ----------------------------------------------------------------------------
    function new_register_store_bus_t (
        register_width_bit : integer; 
        register_count_bit : integer
    ) return register_store_bus_t;

end package;

package body register_store_pkg is 

    ----------------------------------------------------------------------------
    -- @see register_store_pkg.create_register_store_bus_t
    ----------------------------------------------------------------------------
    function create_register_store_bus_t (
        register_store_template : register_store_template_t        
    ) return register_store_bus_t is

        -- Define the constrained subtype locally
        subtype constrained_bus_t is register_store_bus_t(
            inputs(
                write_value (0 to (register_store_template.register_width - 1)),
                index (0 to (register_store_template.register_count_bit - 1))
            ),
            outputs(
                value_out(0 to (register_store_template.register_width - 1))
            )
        );

        variable result : constrained_bus_t;
    begin
        return result;
    end function;

    ----------------------------------------------------------------------------
    -- @see register_store_pkg.new_register_store_template_t
    ----------------------------------------------------------------------------
    function new_register_store_template_t (
        register_width_bit : integer; 
        register_count_bit : integer
    )  return register_store_template_t is

    variable result : register_store_template_t;
    
    begin

        result.register_width_bit := register_width_bit;
        result.register_width := 2 ** register_width_bit;
        
        result.register_count_bit := register_count_bit;
        result.register_count := 2 ** register_count_bit;

        return result;

    end function;

    ----------------------------------------------------------------------------
    -- @see register_store_pkg.new_register_store_bus_t
    ----------------------------------------------------------------------------
    function new_register_store_bus_t (
        register_width_bit : integer; 
        register_count_bit : integer
    ) return register_store_bus_t is 

    begin 

        return create_register_store_bus_t(
            new_register_store_template_t(
                register_width_bit,
                register_count_bit
            )
        );

    end function;

end package body;
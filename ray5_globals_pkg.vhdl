--------------------------------------------------------------------------------
-- Copyright (c) 2026 Mataka Studio. All rights reserved.
-- 
-- @brief A collection of globals used throughout this project. 
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.all; 

package ray5_globals_p is

    ----------------------------------------------------------------------------
    -- @brief Define types for register store. 
    --
    -- @description
    --      The Ray5 ISA will have 8 64 bit general purpose registers, and 8
    --      system registers.
    ----------------------------------------------------------------------------
    package register_store_type is new work.register_store_type_p
    generic map 
    (
        ------------------------------------------------------------------------
        -- @brief Log2 of register width. eg. 2^6 = 64 
        ------------------------------------------------------------------------
        register_width_bit => 6,

        ------------------------------------------------------------------------
        -- @brief Log2 of register count. eg. 2^4 = 16
        --
        -- Reg[0 to 7]  - General purpose registers directly accessible to software. 
        -- 
        -- Reg8         - Program counter. 
        -- Reg[9 to 16] - Unused. ( for now ;) ) 
        ------------------------------------------------------------------------
        register_count_bit => 4
    );

end package;
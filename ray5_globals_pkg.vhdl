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
    --      The Ray5 ISA will have 8 64 bit general purpose registers.
    ----------------------------------------------------------------------------
    package register_store_type is new work.register_store_type_p
    generic map 
    (
        register_width_bit => 6,
        register_count_bit => 3
    );

end package;
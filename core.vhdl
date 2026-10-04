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

entity core is

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
        -- @brief Clock input.
        ------------------------------------------------------------------------
        clock_input : in std_logic; 

        ------------------------------------------------------------------------
        -- @brief Core status.
        -- 
        -- @description 
        --      `1xx` -> Unrecoverable failure.
        --      `000` -> Init state.
        --      `001` -> Unblocked, currently executing.
        --      `010` -> Blocked.
        --                  Generally, this used to signal this core is waiting 
        --                  on memory, however it may also mean the core is 
        --                  waiting on an outside signal.
        ------------------------------------------------------------------------
        core_status_out : out unsigned (0 to 2) := (others => '0')
    );

end;
   
architecture rtl of core is 

    ----------------------------------------------------------------------------
    -- @brief Width of general purpose registers.
    ----------------------------------------------------------------------------
    constant register_width : integer := 2** register_width_bit;

    ----------------------------------------------------------------------------
    -- @brief Number of general purpose registers.
    ----------------------------------------------------------------------------
    constant register_count : integer := 2** register_count_bit;

    ----------------------------------------------------------------------------
    -- @brief Initilization state of core. 
    --
    -- @note 
    --      `0` -> Core is not ready for use.
    --      `1` -> Core is fully initialized, and ready for use.
    ----------------------------------------------------------------------------
    signal core_initialized : std_logic := '0';

begin

    process (clock_input) 
    begin

        -- All core activity occurs on the rising edge.
        if rising_edge(clock_input) then

            if core_initialized = '0' then

                -- Core init process.                          

                -- Signal this core is in the init process. 
                core_status_out <= (others => '0');

            else 

            end if;

        end if;

    end process;

end architecture;
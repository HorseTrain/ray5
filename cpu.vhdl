--------------------------------------------------------------------------------
-- Copyright (c) 2026 Mataka Studio. All rights reserved.
-- 
-- @brief CPU.
-- 
-- @description 
--      Top level ray5 cpu entity.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cpu is 

    port (

        ------------------------------------------------------------------------
        -- @brief Main clock signal that drives the entire cpu.
        ------------------------------------------------------------------------
        CLK100MHZ : in std_logic;

        ------------------------------------------------------------------------
        -- @brief Red heartbeat LED.
        ------------------------------------------------------------------------
        led0_r : out std_logic
    );

end entity;

architecture rtl of cpu is 

    ----------------------------------------------------------------------------
    -- @brief LED test counter.
    ----------------------------------------------------------------------------
    signal led_test : unsigned (0 to 31) := (others => '0');

begin

    process (CLK100MHZ) 
    begin

        if rising_edge(CLK100MHZ) then

            led_test <= led_test + 1;

        end if;

    end process;

    led0_r <= led_test(4);


end architecture;
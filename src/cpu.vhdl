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
use work.core_p.all;
use work.memory_interface_p.all;
use work.ray5_globals_p.all;

entity cpu is

    port (

        ------------------------------------------------------------------------
        -- @brief Main clock signal that drives the entire cpu.
        ------------------------------------------------------------------------
        CLK100MHZ : in std_logic;

        ------------------------------------------------------------------------
        -- @brief Memory.
        ------------------------------------------------------------------------

        -- Outs.
        ddr3_addr           : out std_logic_vector(13 downto 0);
        ddr3_ba             : out std_logic_vector(2 downto 0);
        ddr3_ras_n          : out std_logic;
        ddr3_cas_n          : out std_logic;
        ddr3_we_n           : out std_logic;
        ddr3_reset_n        : out std_logic;
        ddr3_ck_p           : out std_logic_vector(0 downto 0);
        ddr3_ck_n           : out std_logic_vector(0 downto 0);
        ddr3_cke            : out std_logic_vector(0 downto 0);
        ddr3_cs_n           : out std_logic_vector(0 downto 0);
        ddr3_dm             : out std_logic_vector(1 downto 0);
        ddr3_odt            : out std_logic_vector(0 downto 0);

        -- In outs.
        ddr3_dq             : inout std_logic_vector(15 downto 0);
        ddr3_dqs_p          : inout std_logic_vector(1 downto 0);
        ddr3_dqs_n          : inout std_logic_vector(1 downto 0);
        
        ------------------------------------------------------------------------
        -- @brief LED's.
        ------------------------------------------------------------------------
        led                 : out unsigned (0 to 3)
    );

end entity;

architecture rtl of cpu is

    ----------------------------------------------------------------------------
    -- @brief The amount of core in a CPU.
    ----------------------------------------------------------------------------
    constant core_count : integer := 8;

    ----------------------------------------------------------------------------
    -- @brief Collection of core busses definition.
    ----------------------------------------------------------------------------
    type core_bus_collection_t is array (0 to (core_count - 1)) of core_bus_t;

    ----------------------------------------------------------------------------
    -- @brief Collection of cure busses.
    ----------------------------------------------------------------------------
    signal core_bus_collection : core_bus_collection_t;

    ----------------------------------------------------------------------------
    -- @brief LED test counter.
    ----------------------------------------------------------------------------
    signal led_test : unsigned (0 to 31) := (others => '0');

    ----------------------------------------------------------------------------
    -- @brief Definition of CPU states.
    ----------------------------------------------------------------------------
    type cpu_state_t is (

        -- Cpu is initializing all components.
        CPU_STATE_INITIALIZING,

        -- Cpu is initializing core 0 to begin execution.
        CPU_STATE_INITIALIZE_CORE_0,

        -- Cpu is in an error state, and needs a restart.
        CPU_STATE_ERROR
    );

    ----------------------------------------------------------------------------
    -- @brief Current cpu state.
    ----------------------------------------------------------------------------
    signal cpu_state : cpu_state_t := CPU_STATE_INITIALIZING;

    ----------------------------------------------------------------------------
    -- @brief Initiation timer. 
    ----------------------------------------------------------------------------
    constant INIT_TIME_PERIODS : integer := BASE_CLOCK_RATE * 5;

    -- Init timer. 
    signal init_timer : integer range 0 to INIT_TIME_PERIODS := 0;

    -- Minimum initiation time passed. 
    signal init_time_ready : std_logic := '0';

    ----------------------------------------------------------------------------
    -- @brief Core initialization signals.
    ----------------------------------------------------------------------------

    -- Loop index for ready check.
    signal cores_ready_check_idx : integer range 0 to (core_count + 1) := 0;

    -- All ready check.
    signal cores_ready_check : std_logic := '0';

    -- Core ready flag.
    signal cores_ready : std_logic := '0';

    ----------------------------------------------------------------------------
    -- @brief Clocks.
    ----------------------------------------------------------------------------

    -- 100 mhz clock.
    signal system_clock_100mhz : std_logic := '0';

    -- 200 mhz clock.
    signal system_clock_200mhz : std_logic := '0';

    -- 400 mhz clock.
    signal system_clock_400mhz : std_logic := '0';

    -- Main clock.
    signal clock_input : std_logic := '0';

    ----------------------------------------------------------------------------
    -- @brief Memory interface bus.
    ----------------------------------------------------------------------------
    signal memory_interface_bus : memory_interface_bus_t;

    -- Memory ready flag. 
    signal memory_ready : std_logic := '0';
    
    ----------------------------------------------------------------------------
    -- @brief LED patterns. 
    ----------------------------------------------------------------------------

    subtype green_led_pattern_t is unsigned (0 to 3);
 
    -- Green LED init pattern. 
    signal green_led_init_pattern : green_led_pattern_t; 

    -- Green LED idle pattern.
    signal green_led_idle_pattern : green_led_pattern_t;

begin

    clock_wizzard : entity work.clock_wizzard
    port map (

        -- Inputs
        in_100mhz => CLK100MHZ,
        reset => '0',

        -- Outputs
        out_100mhz => system_clock_100mhz,
        out_200mhz => system_clock_200mhz,
        out_400mhz => system_clock_400mhz
    );

    clock_input <= system_clock_100mhz;

    ----------------------------------------------------------------------------
    -- Instantiate our cores.
    ----------------------------------------------------------------------------
    cores : for i in 0 to (core_count - 1) generate
    begin

        core_i : entity work.core
        port map (
            inputs => core_bus_collection(i).inputs,
            outputs => core_bus_collection(i).outputs
        );

        -- Route clock clock into cores.
        core_bus_collection(i).inputs.clock_input <= clock_input;

    end generate;

    ----------------------------------------------------------------------------
    -- Instantiate memory interface.
    ----------------------------------------------------------------------------

    -- Wire clocks.
    memory_interface_bus.inputs.system_clock <= system_clock_100mhz;
    memory_interface_bus.inputs.reference_clock <= system_clock_200mhz;

    -- Memory interface instance.
    memory_interface : entity work.memory_interface
    port map (
        inputs => memory_interface_bus.inputs,
        outputs => memory_interface_bus.outputs,

        ddr3_outputs => memory_interface_bus.ddr3_outputs,
        ddr3_in_outs => memory_interface_bus.ddr3_in_outs
    );

    -- Wire DDR3 outputs. 
    ddr3_addr <= memory_interface_bus.ddr3_outputs.ddr3_addr;
    ddr3_ba <= memory_interface_bus.ddr3_outputs.ddr3_ba;
    ddr3_ras_n <= memory_interface_bus.ddr3_outputs.ddr3_ras_n;
    ddr3_cas_n <= memory_interface_bus.ddr3_outputs.ddr3_cas_n;
    ddr3_we_n <= memory_interface_bus.ddr3_outputs.ddr3_we_n;
    ddr3_reset_n <= memory_interface_bus.ddr3_outputs.ddr3_reset_n;
    ddr3_ck_p <= memory_interface_bus.ddr3_outputs.ddr3_ck_p;
    ddr3_ck_n <= memory_interface_bus.ddr3_outputs.ddr3_ck_n;
    ddr3_cke <= memory_interface_bus.ddr3_outputs.ddr3_cke;
    ddr3_cs_n <= memory_interface_bus.ddr3_outputs.ddr3_cs_n;
    ddr3_dm <= memory_interface_bus.ddr3_outputs.ddr3_dm;
    ddr3_odt <= memory_interface_bus.ddr3_outputs.ddr3_odt;

    -- Wire DDR3 in/outs.
    ddr3_dq <= memory_interface_bus.ddr3_in_outs.ddr3_dq;
    ddr3_dqs_p <= memory_interface_bus.ddr3_in_outs.ddr3_dqs_p;
    ddr3_dqs_n <= memory_interface_bus.ddr3_in_outs.ddr3_dqs_n;

    ----------------------------------------------------------------------------
    -- LEDs.
    ----------------------------------------------------------------------------

    green_led_init_pattern <= "00" & led_test(7 to 8); 
    green_led_idle_pattern <= shift_left(to_unsigned(1, 4), to_integer(led_test(6 to 7)));

    ----------------------------------------------------------------------------
    -- CPU Process.
    ----------------------------------------------------------------------------

    process (clock_input) is
    begin

        if rising_edge(clock_input) then

            -- Oscillate red LED.
            led_test <= led_test + 1;

            case cpu_state is

                when CPU_STATE_INITIALIZING =>

                    -- Pulse the LED to signal the cpu is initializing.
                    led <= green_led_init_pattern;

                    -- Only initiate the cores if they are not ready.
                    if cores_ready = '0' then
                        -- Increment the check index.
                        cores_ready_check_idx <= cores_ready_check_idx + 1;

                        if cores_ready_check_idx < core_count then

                            -- If the core being checked
                            if not (core_bus_collection(cores_ready_check_idx).outputs.core_status_out = CORE_STATUS_OUT_IDLE) then

                                -- If the core is not ready, set the signal low.
                                cores_ready_check <= '0';
                            end if;

                        end if;

                        -- If the core check hits the end reset.
                        if cores_ready_check_idx = core_count then

                            -- If all the cores are idle, transition to initializing
                            -- core zero to begin execution.
                            if cores_ready_check = '1' then

                                cores_ready <= '1';

                            else

                                cores_ready_check_idx <= 0;
                                cores_ready_check <= '1';

                            end if;

                        end if;
                    end if;

                    -- Only initiate the memory if it is not ready.
                    if memory_ready = '0' then

                        if memory_interface_bus.outputs.ready = '1' then
                            memory_ready <= '1';
                        end if;

                    end if;

                    -- Only leave init state after a few seconds.
                    if init_time_ready = '0' then

                        init_timer <= init_timer + 1;

                        if init_timer = INIT_TIME_PERIODS then
                            init_time_ready <= '1';
                        end if;

                    end if;

                    -- Check all conditions to transition.
                    if 
                        (cores_ready = '1') and 
                        (memory_ready = '1') and 
                        (init_time_ready = '1') 
                    then

                        cpu_state <= CPU_STATE_INITIALIZE_CORE_0;

                    end if;

                when CPU_STATE_INITIALIZE_CORE_0 =>

                    -- Set the core0 entry point.

                    led <= green_led_idle_pattern;


                when others =>

                    -- Processor is hung up, and requires a restart.
                    led <= "1111";

                    null;

            end case ;

        end if;

    end process;

end architecture;
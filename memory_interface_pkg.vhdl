--------------------------------------------------------------------------------
-- Copyright (c) 2026 Mataka Studio. All rights reserved.
-- 
-- @brief Memory interface package. 
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ray5_globals_p.all;

package memory_interface_p is 

    ----------------------------------------------------------------------------
    -- @brief Memory interface command type.
    ----------------------------------------------------------------------------
    type memory_interface_command_t is (

        -- Read
        MEMORY_INTERFACE_COMMAND_READ, 

        -- Write
        MEMORY_INTERFACE_COMMAND_WRITE
    );

    ----------------------------------------------------------------------------
    -- @brief Ripped straight from MIG.
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- @brief Ddr3 app input bus.
    ----------------------------------------------------------------------------
    type memory_interface_inputs_app_t is record 

        app_addr        : std_logic_vector(27 downto 0);
        app_cmd         : std_logic_vector(2 downto 0);
        app_en          : std_logic;
        app_wdf_data    : std_logic_vector(63 downto 0);
        app_wdf_end     : std_logic;
        app_wdf_mask    : std_logic_vector(7 downto 0);
        app_wdf_wren    : std_logic;
        app_sr_req      : std_logic;
        app_ref_req     : std_logic;
        app_zq_req      : std_logic;
        
        sys_clk_i       : std_logic;
        clk_ref_i       : std_logic;
        sys_rst         : std_logic;

    end record memory_interface_inputs_app_t;

    ----------------------------------------------------------------------------
    -- @brief Ddr3 app outputs bus.
    ----------------------------------------------------------------------------
    type memory_interface_outputs_app_t is record 

        app_rd_data         : std_logic_vector(63 downto 0);
        app_rd_data_end     : std_logic;
        app_rd_data_valid   : std_logic;
        app_rdy             : std_logic;
        app_wdf_rdy         : std_logic;
        app_sr_active       : std_logic;
        app_ref_ack         : std_logic;
        app_zq_ack          : std_logic;
        ui_clk              : std_logic;
        ui_clk_sync_rst     : std_logic;
        init_calib_complete : std_logic;
        device_temp         : std_logic_vector(11 downto 0);

    end record memory_interface_outputs_app_t;

    ----------------------------------------------------------------------------
    -- @brief Ddr3 input output bus.
    ----------------------------------------------------------------------------
    type memory_interface_outputs_ddr3_t is record 

        ddr3_addr           : std_logic_vector(13 downto 0);
        ddr3_ba             : std_logic_vector(2 downto 0);
        ddr3_ras_n          : std_logic;
        ddr3_cas_n          : std_logic;
        ddr3_we_n           : std_logic;
        ddr3_reset_n        : std_logic;
        ddr3_ck_p           : std_logic_vector(0 downto 0);
        ddr3_ck_n           : std_logic_vector(0 downto 0);
        ddr3_cke            : std_logic_vector(0 downto 0);
        ddr3_cs_n           : std_logic_vector(0 downto 0);
        ddr3_dm             : std_logic_vector(0 downto 0);
        ddr3_odt            : std_logic_vector(0 downto 0);

    end record memory_interface_outputs_ddr3_t;

    ----------------------------------------------------------------------------
    -- @brief Ddr3 input output bus.
    ----------------------------------------------------------------------------
    type memory_interface_in_outs_ddr3_t is record 
        ddr3_dq       : std_logic_vector(7 downto 0);
        ddr3_dqs_p    : std_logic_vector(0 downto 0);
        ddr3_dqs_n    : std_logic_vector(0 downto 0);
    end record memory_interface_in_outs_ddr3_t;

    ----------------------------------------------------------------------------
    -- @brief Interface input bus.
    ----------------------------------------------------------------------------
    type memory_interface_inputs_t is record 

        ------------------------------------------------------------------------
        -- @brief Clock input.
        ------------------------------------------------------------------------
        clock_input : std_logic;

        ------------------------------------------------------------------------
        -- @brief Address.
        ------------------------------------------------------------------------
        address : register_store_type.register_t;

        ------------------------------------------------------------------------
        -- @brief Memory interface command.
        ------------------------------------------------------------------------
        command : memory_interface_command_t;

        ------------------------------------------------------------------------
        -- @brief Value in.
        ------------------------------------------------------------------------
        value : register_store_type.register_t;

        ------------------------------------------------------------------------
        -- @brief Amount of bytes. 
        ------------------------------------------------------------------------
        size : register_store_type.register_size_t;

        ------------------------------------------------------------------------
        -- @brief If high, memory will begin executing its command.
        ------------------------------------------------------------------------
        start_command : std_logic;

    end record memory_interface_inputs_t;
    
    ------------------------------------------------------------------------
    -- @brief Interface output bus.
    ------------------------------------------------------------------------
    type memory_interface_outputs_t is record 

        ------------------------------------------------------------------------
        -- @brief Output from memory.
        ------------------------------------------------------------------------
        value : register_store_type.register_t;

        ------------------------------------------------------------------------
        -- @brief Command finished.
        ------------------------------------------------------------------------
        command_finished : std_logic;

        ------------------------------------------------------------------------
        -- @brief Ready.
        ------------------------------------------------------------------------
        ready : std_logic;

    end record memory_interface_outputs_t;

    ------------------------------------------------------------------------
    -- @brief Full interface bus.
    ------------------------------------------------------------------------
    type memory_interface_bus_t is record 

        -- Inputs 
        inputs : memory_interface_inputs_t;

        -- Outputs 
        outputs : memory_interface_outputs_t;

        -- Ddr3 outputs 
        ddr3_outputs : memory_interface_outputs_ddr3_t;

        -- Ddr3 in outs 
        ddr3_in_outs : memory_interface_in_outs_ddr3_t;

    end record memory_interface_bus_t;

end package;
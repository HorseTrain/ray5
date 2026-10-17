--------------------------------------------------------------------------------
-- Copyright (c) 2026 Mataka Studio. All rights reserved.
-- 
-- @brief Synchronous memory interface wrapper for Vivado.
--------------------------------------------------------------------------------



library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.memory_interface_p.all;

entity memory_interface is 

    port (

        -- Inputs 
        inputs : in memory_interface_inputs_t;

        -- Outputs 
        outputs : out memory_interface_outputs_t;

        -- Ddr3 inputs 
        ddr3_outputs : out memory_interface_outputs_ddr3_t;

        -- Ddr3 in outs 
        ddr3_in_outs : inout memory_interface_in_outs_ddr3_t
    );

end entity;

architecture rtl of memory_interface is 

    ----------------------------------------------------------------------------
    -- @brief State names.
    ----------------------------------------------------------------------------
    type state_name_t is (

        -- Initializing
        STATE_INITIALIZING,

        -- Idle
        STATE_IDLE
    );

    ----------------------------------------------------------------------------
    -- @brief Current state.
    ----------------------------------------------------------------------------
    signal state : state_name_t := STATE_INITIALIZING;

    ----------------------------------------------------------------------------
    -- @brief Finished with command signal.
    ----------------------------------------------------------------------------
    signal command_finished : std_logic := '0'; 

    ----------------------------------------------------------------------------
    -- @brief Memory app inputs.
    ----------------------------------------------------------------------------
    signal app_inputs : memory_interface_inputs_app_t;

    ----------------------------------------------------------------------------
    -- @brief Memory app outputs.
    ----------------------------------------------------------------------------
    signal app_outputs : memory_interface_outputs_app_t;

begin

    -- Keep all input pins low.
    app_inputs.app_addr <= (others => '0');
    app_inputs.app_cmd <= (others => '0');
    app_inputs.app_wdf_data <= (others => '0');
    app_inputs.app_wdf_mask <= (others => '0'); 
    
    app_inputs.app_en        <= '0';
    app_inputs.app_wdf_end   <= '0';
    app_inputs.app_wdf_wren  <= '0';
    app_inputs.app_sr_req    <= '0';
    app_inputs.app_ref_req   <= '0';
    app_inputs.app_zq_req    <= '0'; 
    app_inputs.sys_rst       <= '1';

    process (inputs.system_clock) 
    begin

        if rising_edge(inputs.system_clock) then

            case state is 

                when others => 

                    -- TODO:

                    null;

            end case; 

        end if;
    
    end process;

    app_inputs.sys_clk_i <= inputs.system_clock;     
    app_inputs.clk_ref_i <= inputs.reference_clock;

    -- Mig instantiation 
    mig : entity work.mig_interface 
    port map (

        -- Internal app inputs.
        app_addr     => app_inputs.app_addr    ,
        app_cmd      => app_inputs.app_cmd     ,
        app_en       => app_inputs.app_en      ,
        app_wdf_data => app_inputs.app_wdf_data,
        app_wdf_end  => app_inputs.app_wdf_end ,
        app_wdf_mask => app_inputs.app_wdf_mask,
        app_wdf_wren => app_inputs.app_wdf_wren,
        app_sr_req   => app_inputs.app_sr_req  ,
        app_ref_req  => app_inputs.app_ref_req ,
        app_zq_req   => app_inputs.app_zq_req  ,
        sys_clk_i    => app_inputs.sys_clk_i   ,
        clk_ref_i    => app_inputs.clk_ref_i   ,
        sys_rst      => app_inputs.sys_rst     , 

        -- Internal app outputs.
        app_rd_data         => app_outputs.app_rd_data         ,
        app_rd_data_end     => app_outputs.app_rd_data_end     ,
        app_rd_data_valid   => app_outputs.app_rd_data_valid   ,
        app_rdy             => app_outputs.app_rdy             ,
        app_wdf_rdy         => app_outputs.app_wdf_rdy         ,
        app_sr_active       => app_outputs.app_sr_active       ,
        app_ref_ack         => app_outputs.app_ref_ack         ,
        app_zq_ack          => app_outputs.app_zq_ack          ,
        ui_clk              => app_outputs.ui_clk              ,
        ui_clk_sync_rst     => app_outputs.ui_clk_sync_rst     ,
        init_calib_complete => app_outputs.init_calib_complete ,
        device_temp         => app_outputs.device_temp         ,

        -- External ddr3 outputs.
        ddr3_addr           => ddr3_outputs.ddr3_addr           ,
        ddr3_ba             => ddr3_outputs.ddr3_ba             ,
        ddr3_ras_n          => ddr3_outputs.ddr3_ras_n          ,
        ddr3_cas_n          => ddr3_outputs.ddr3_cas_n          ,
        ddr3_we_n           => ddr3_outputs.ddr3_we_n           ,
        ddr3_reset_n        => ddr3_outputs.ddr3_reset_n        ,
        ddr3_ck_p           => ddr3_outputs.ddr3_ck_p           ,
        ddr3_ck_n           => ddr3_outputs.ddr3_ck_n           ,
        ddr3_cke            => ddr3_outputs.ddr3_cke            ,
        ddr3_cs_n           => ddr3_outputs.ddr3_cs_n           ,
        ddr3_dm             => ddr3_outputs.ddr3_dm             ,
        ddr3_odt            => ddr3_outputs.ddr3_odt            ,

        -- External ddr3 in outs.
        ddr3_dq    => ddr3_in_outs.ddr3_dq   ,
        ddr3_dqs_p => ddr3_in_outs.ddr3_dqs_p,
        ddr3_dqs_n => ddr3_in_outs.ddr3_dqs_n
    );

    -- Pipe finished.
    outputs.command_finished <= command_finished;

end architecture;
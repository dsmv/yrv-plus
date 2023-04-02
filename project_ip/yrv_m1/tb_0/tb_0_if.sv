

interface tb_0_if( input clk );


    // ports of yrv_m1

    // clk is part of constructor  //logic           clk;          // cpu clock
    logic           ei_req;       // external int request
    logic           nmi_req;      // non-maskable interrupt
    logic           resetn;
    logic           ser_rxd;      // receive data input
    logic [15:0]    port4_in;     // port 4
    logic [15:0]    port5_in;     // port 5
    
    logic           debug_mode;   // in debug mode
    logic           ser_clk;      // serial clk output (cks mode)
    logic           ser_txd;      // transmit data output
    logic           wfi_state;    // waiting for interrupt
    logic  [15:0]   port0_reg;    // port 0
    logic  [15:0]   port1_reg;    // port 1
    logic  [15:0]   port2_reg;    // port 2
    logic  [15:0]   port3_reg;    // port 3
    logic           aux_uart_rx;  /* auxiliary UART receive pin   */


    // variable
    logic [7:0]     _q_rx[$];  //! queue for rx data

    logic [7:0]     _q_tx[$];  //! queue for tx data

    logic           rx_start;
    logic           rx_step;
    logic           rx_stop;
    logic [7:0]     rx_data;
    
    task init;

        ei_req = 0;
        nmi_req = 0;
        resetn  = 0;
        ser_rxd  = 0;
        port4_in = '0;
        port5_in = '0;
        aux_uart_rx = 0;

        rx_start = 0;
        rx_step = 0;
        rx_stop = 0;
        rx_data = '0;
        fork
            grab_rx();
            send_tx();
        join_none

    endtask

    task set_reset( 
        input int state     //! 1 - reset state, 0 - unreset state
    );
        @(posedge clk);
        resetn <= #1 (0==state) ? 1 : 0;

    endtask

    task grab_rx();

        automatic int           state=0;
        automatic int           stop_bit;
        //automatic int           full_period_cnt=80;
        automatic int           full_period_cnt=430;
        automatic logic [7:0]   rx;


        state = 0;
        for( ; ; ) begin

            @(posedge clk iff ~ser_txd); // wait for start bit
            rx_start = 1;
            repeat (full_period_cnt) @(posedge clk);
            rx_start = 0;
            repeat (full_period_cnt/2) @(posedge clk);

            for( int ii=0; ii<8; ii++ ) begin
                rx[ii] = ser_txd;
                rx_step = 1;
                @(posedge clk);
                rx_step = 0;
                repeat (full_period_cnt) @(posedge clk);
            end

            stop_bit = ser_txd;

            if( 1==stop_bit ) begin
                _q_rx.push_back(rx);
                rx_stop=1;
                rx_data = rx;
                repeat (full_period_cnt/4) @(posedge clk);
                rx_stop=0;
            end else begin
                @(posedge clk iff ser_txd); // wait for ser_txd=1
            end

       end

    endtask

    task send_tx();

        automatic int           full_period_cnt=430;
        automatic logic [7:0]   tx;


        ser_rxd <= 1;
        
        for( ; ; ) begin
            @(posedge clk iff _q_tx.size()!=0 );
            tx = _q_tx.pop_front();

            ser_rxd <= #1 0;
            repeat (full_period_cnt) @(posedge clk);

            for( int ii=0; ii<8; ii++ ) begin
                ser_rxd <= #1 tx[ii];
                repeat (full_period_cnt) @(posedge clk);
            end

            ser_rxd <= #1 1;
            repeat (full_period_cnt) @(posedge clk);

            repeat (full_period_cnt/4) @(posedge clk);
        end


    endtask

endinterface //tb_8_if



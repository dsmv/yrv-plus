
`default_nettype none 

module top
# (
    parameter clk_mhz = 50
)
(
    input   wire        clk,
    input   wire        reset_n,
    
    input   wire [3:0]  key_sw,
    output  wire [3:0]  led,

    output  wire [7:0]  abcdefgh,
    output  wire [3:0]  digit,

    output  wire        buzzer,

    output  wire        hsync,
    output  wire        vsync,
    output  wire [2:0]  rgb,

    input   wire        uart_rxd,
    output  wire        uart_txd
);

//assign led       = key_sw;
//assign abcdefgh  = { key_sw, key_sw };
//assign digit     = 4'b0;
assign buzzer       = 1'b0;
assign  hsync       = 0;
assign  vsync       = 0;
assign  rgb         = '0;


logic              interface_rstp;
logic [15:0]       display_number;

logic [3:0]        key_sw_z;

logic [3:0]        key_sw_p;

logic [3:0]        led_p;

logic  [15:0] port4_in;                                  /* port 4                       */
logic  [15:0] port5_in;                                  /* port 5                       */

logic        debug_mode;                                /* in debug mode                */
logic        ser_clk;                                   /* serial clk output (cks mode) */
logic        wfi_state;                                 /* waiting for interrupt        */
logic [15:0] port0_reg;                                 /* port 0                       */
logic [15:0] port1_reg;                                 /* port 1                       */
logic [15:0] port2_reg;                                 /* port 2                       */
logic [15:0] port3_reg;                                 /* port 3                       */

logic               reset_n1;
logic               reset_n2;
logic               cpu_reset_n;
logic               aux_uart_rxd;

sync_and_debounce 
#(
    .w          (   4   ),
    .depth      (   8   )
)
sync_and_debounce 
(   
    .clk            (       clk           ),
    .reset          (       interface_rstp  ),
    .sw_in          (       key_sw          ),
    .sw_out         (       key_sw_z        )
);

 seven_segment_4_digits display
 (
     .clock         (       clk             ),
     .reset         (       interface_rstp    ),
     .number        (       display_number  ),
 
     .abcdefgh      (       abcdefgh        ),
     .digit         (       digit           )
 );


assign key_sw_p     = ~ key_sw_z;
assign led          = ~led_p;

always @(posedge clk ) begin
    reset_n1    <= #1 reset_n;
    reset_n2    <= #1 reset_n1;
    cpu_reset_n <= #1 reset_n2 & key_sw_z[3];

    interface_rstp <= #1 ~reset_n2;
end
yrv_m1 yrv_m1
(
  .clk,                                       /* cpu clock                    */
  .ei_req       (   0   ),                                    /* external int request         */
  .nmi_req      (   0   ),                                   /* non-maskable interrupt       */
  .resetn       (   cpu_reset_n     ),                                    /* master reset                 */
  .ser_rxd      (   uart_rxd    ),                                   /* receive data input           */
  .port4_in,                                  /* port 4                       */
  .port5_in,                                  /* port 5                       */

  .debug_mode,                                /* in debug mode                */
  .ser_clk,                                   /* serial clk output (cks mode) */
  .ser_txd      (   uart_txd    ),                                   /* transmit data output         */
  .wfi_state,                                 /* waiting for interrupt        */
  .port0_reg,                                 /* port 0                       */
  .port1_reg,                                 /* port 1                       */
  .port2_reg,                                 /* port 2                       */
  .port3_reg,                                 /* port 3                       */

  .aux_uart_rx  (  aux_uart_rxd  )                /* auxiliary UART receive pin   */
);

assign aux_uart_rxd = uart_rxd | port2_reg[15];

always @(posedge clk) begin
    display_number[15:0]  <= #1 port0_reg;
    led_p                 <= #1 port2_reg[3:0];
    port4_in        <= #1 key_sw_p;
    //buzzer          <= #1 0; //port2_reg[0];
end

endmodule

`default_nettype wire
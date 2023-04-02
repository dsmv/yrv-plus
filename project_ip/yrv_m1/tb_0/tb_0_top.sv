
`timescale 1 ns / 1 ns
`default_nettype none 


import tb_0_pkg::*;

module tb_0_top
  ();
  
  int       test_id=0;
  
  string  tb_name = "tb_0_serial";

  string	test_name[1:0]=
  {
   "randomize", 
   "direct_base" 
  };
  
localparam  WIDTH = 16;

// initial begin
//   $dumpfile("dump.vcd");
//   $dumpvars(1);
// end



task test_finish;
  		input int 	test_id;
  		input string	test_name;
  		input int		result;
begin

    automatic int fd = $fopen( "global.txt", "a" );

    $display("");
    $display("");

    if( 1==result ) begin
        $fdisplay( fd, "tb_name: %25s test_id=%-5d test_name: %25s         TEST_PASSED", 
        tb_name, test_id, test_name );
        $display(      "tb_name: %25s test_id=%-5d test_name: %25s         TEST_PASSED", 
        tb_name, test_id, test_name );
    end else begin
        $fdisplay( fd, "tb_name: %25s test_id=%-5d test_name: %25s         TEST_FAILED *******", 
        tb_name, test_id, test_name );
        $display(      "tb_name: %25s test_id=%-5d test_name: %25s         TEST_FAILED *******", 
        tb_name, test_id, test_name );
    end

    $fclose( fd );

    $display("");
    $display("");

    $finish();
end endtask  
  
/////////////////////////////////////////////////////////////////


//logic                   reset_p;    //! 1 - reset
logic                   clk=0;        //! clock
logic    [WIDTH-1:0]    data_i=0;
logic                   data_we=0;
logic    [WIDTH-1:0]    data_o;
logic                   data_rd=0;
logic                   full;
logic                   empty;

int                     cnt_wr=0;
int                     cnt_rd=0;
int                     cnt_ok=0;  
int                     cnt_error=0;

int                     show_ok=0;
int                     show_error=0;

logic                   test_start=0;
logic                   test_timeout=0;
logic                   test_done=0;

int                     tick_current=0;


real                    cv_all;


always #10 clk = ~clk;

//always @(posedge clk ) cv_all = $get_coverage();


initial begin
    //#800000;
    #6000000;
    $display( "Timeout");
    test_timeout = '1;
end


// Main process  
initial begin  

    automatic int args=-1;
    automatic int current_delay;
    automatic int cnt;

   
    if( $value$plusargs( "test_id=%0d", args )) begin
        if( args>=0 && args<4 )
        test_id = args;

        $display( "args=%d  test_id=%d", args, test_id );

    end

    $display("%s  test_id=%d  name: %s", tb_name, test_id, test_name[test_id] );
    
    //reset_p <= #1 '1;
    //#400;

    test_init();

    #100;

    //reset_p <= #1 '0;

    repeat (1) @(posedge clk );

    test_start <= #1 '1;

    @(posedge clk iff test_done=='1 || test_timeout=='1);

    if( test_timeout )
        cnt_error++;

    $display( "cnt_wr: %d", cnt_wr );
    $display( "cnt_rd: %d", cnt_rd );
    $display( "cnt_ok: %d", cnt_ok );
    $display( "cnt_error: %d", cnt_error );


    //$display("overall coverage = %0f", $get_coverage());
    // $display("coverage of covergroup cg = %0f", uut.dut.cg.get_coverage());
    // $display("coverage of covergroup cg.wr_en  = %0f", uut.dut.cg.wr_en.get_coverage());
    // $display("coverage of covergroup cg.full   = %0f", uut.dut.cg.full.get_coverage());
    // $display("coverage of covergroup cg.rd_en  = %0f", uut.dut.cg.rd_en.get_coverage());
    // $display("coverage of covergroup cg.empty  = %0f", uut.dut.cg.empty.get_coverage());
    // $display("coverage of covergroup cg.we_full  = %0f", uut.dut.cg.we_full.get_coverage());
    // $display("coverage of covergroup cg.rd_empty  = %0f", uut.dut.cg.rd_empty.get_coverage());
    //$display("coverage of covergroup cg.FIFO_cnt   = %0f", uut.dut.cg.FIFO_cnt.get_coverage());

    if( 0==cnt_error && cnt_ok>0 )
        test_finish( test_id, test_name[test_id], 1 );  // test passed
    else
        test_finish( test_id, test_name[test_id], 0 );  // test failed



end
  

always @(posedge clk)  if( test_start ) tick_current <= #1 tick_current+1;

// Generate test sequence 
initial begin

  @(posedge clk iff test_start=='1);

  case( test_id )
  0: begin

        tb_0_read_hello_world();
        tb_0_echo();
        tb_0_get_result( cnt_wr, cnt_rd, cnt_ok, cnt_error );
  end





  endcase


  #500;

  test_done=1;

end 


////////////////////////////////////////////////////////////////////////

tb_0_if          uut_cn0( clk );


task test_init;

    _cn0 = uut_cn0;


    _cn0.init();
    tb_0_init();

endtask
yrv_m1 yrv_m1
(
  .clk              (       clk                     ),
  .ei_req           (       uut_cn0.ei_req          ),
  .nmi_req          (       uut_cn0.nmi_req         ),
  .resetn           (       uut_cn0.resetn          ),
  .ser_rxd          (       uut_cn0.ser_rxd         ),
  .port4_in         (       uut_cn0.port4_in        ),
  .port5_in         (       uut_cn0.port5_in        ),
  .debug_mode       (       uut_cn0.debug_mode      ),
  .ser_clk          (       uut_cn0.ser_clk         ),
  .ser_txd          (       uut_cn0.ser_txd         ),
  .wfi_state        (       uut_cn0.wfi_state       ),
  .port0_reg        (       uut_cn0.port0_reg       ),
  .port1_reg        (       uut_cn0.port1_reg       ),
  .port2_reg        (       uut_cn0.port2_reg       ),
  .port3_reg        (       uut_cn0.port3_reg       ),
  .aux_uart_rx      (       uut_cn0.aux_uart_rx     )
  //.aux_uart_rx      (       uut_cn0.ser_rxd     )
);

assign uut_cn0.aux_uart_rx = uut_cn0.ser_rxd | uut_cn0.port2_reg[15];


endmodule

`default_nettype wire
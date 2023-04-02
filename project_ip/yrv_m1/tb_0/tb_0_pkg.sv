

package tb_0_pkg;


import tb_0_fabric_pkg::*;


    // class
    tb_0_fabric             _fabric;

    // interface
    virtual tb_0_if         _cn0;

    // variable
    int                     _cnt_wr=0;
    int                     _cnt_rd=0;
    int                     _cnt_ok=0; 
    int                     _cnt_error=0; 

    // task
    task tb_0_init();

        _fabric = new();

        _cn0.set_reset( 0 ); // unreset

        #20000;

        //tb_0_load_program();

    endtask

    task tb_0_load_program();

        automatic int           fd;
        automatic logic [7:0]   val;
        automatic int           index;

        fd = $fopen( "../p0_text.hex", "r" );
        //fd = $fopen( "../code_demo.mem32", "r" );

        index=0;
        for( ; ; ) begin
            if( $feof(fd) )
                break;
            val =  $fgetc(fd);
            _cn0._q_tx.push_back( val );
            $display( "send: %4d  %c - 0x%h", index, val, val );
            index++;

        end



    endtask

    task tb_0_read_hello_world();

        automatic logic [7:0]   rx;
        automatic string        str;
        automatic int           index;
        automatic string        expect_str;
        automatic string        r="0";
        index = 0;
        for( ; ; ) begin
            if( _cn0._q_rx.size() ) begin
                rx = _cn0._q_rx.pop_front();
                $display( "rx %d : %h %c ", index, rx, rx ); index++;
                if( rx==8'h0A )
                    break;
                if( rx==8'h0D )
                    continue;

                r.putc(0, rx);
                str = {str,r};
                

            end else begin
                #100;
            end
        end

        _cnt_rd++;
        expect_str="Hello, world! 123 ";

        if( str==expect_str ) begin
            $display( "serial_rx: %s - Ok", str );    
            _cnt_ok++;
        end else begin
            $display( "serial_rx: '%s' - Error", str );    
            $display( "expect   : '%s'", expect_str );    
            _cnt_error++;
            
        end

        

    endtask

    task tb_0_echo();

        automatic logic [7:0]   rx;
        automatic string        str;
        automatic int           index;
        automatic string        expect_str;
        automatic string        r="0";

        
        expect_str="0123456789";

        for( int ii=0; ii<10; ii++ ) begin
            _cn0._q_tx.push_back( expect_str[ii] );
            _cnt_wr++;
        end
        _cn0._q_tx.push_back( 8'h0A );
        _cnt_wr++;




        index = 0;
        for( ; ; ) begin
            if( _cn0._q_rx.size() ) begin
                rx = _cn0._q_rx.pop_front();
                $display( "rx %d : %h %c ", index, rx, rx ); index++;
                if( rx==8'h0A )
                    break;
                if( rx==8'h0D )
                    continue;
                r.putc(0, rx);
                str = {str,r};
                

            end else begin
                #100;
            end
        end

        _cnt_rd++;
        

        if( str==expect_str ) begin
            $display( "serial_rx: %s - Ok", str );    
            _cnt_ok++;
        end else begin
            $display( "serial_rx: '%s' - Error", str );    
            $display( "expect   : '%s'", expect_str );    
            _cnt_error++;
            
        end

        

    endtask

    task tb_0_get_result
    ( 
        output int cnt_wr, 
        output int cnt_rd, 
        output int cnt_ok, 
        output int cnt_error 
    );
        cnt_wr = _cnt_wr;
        cnt_rd = _cnt_rd;
        cnt_ok = _cnt_ok;
        cnt_error = _cnt_error;

    endtask

endpackage
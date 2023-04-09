/*******************************************************************************************/
/**                                                                                       **/
/** Copyright 2021 Monte J. Dalrymple                                                     **/
/**                                                                                       **/
/** SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1                                      **/
/**                                                                                       **/
/** Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may not use  **/
/** this file except in compliance with the License, or, at your option, the Apache       **/
/** License version 2.0. You may obtain a copy of the License at                          **/
/**                                                                                       **/
/** https://solderpad.org/licenses/SHL-2.1/                                               **/
/**                                                                                       **/
/** Unless required by applicable law or agreed to in writing, any work distributed under **/
/** the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF   **/
/** ANY KIND, either express or implied. See the License for the specific language        **/
/** governing permissions and limitations under the License.                              **/
/**                                                                                       **/
/** YRV simple mcu system                                             Rev 0.0  03/29/2021 **/
/**                                                                                       **/
/*******************************************************************************************/

module yrv_m1
(
  input         clk,                                       /* cpu clock                    */
  input         ei_req,                                    /* external int request         */
  input         nmi_req,                                   /* non-maskable interrupt       */
  input         resetn,                                    /* master reset                 */
  input         ser_rxd,                                   /* receive data input           */
  input  [15:0] port4_in,                                  /* port 4                       */
  input  [15:0] port5_in,                                  /* port 5                       */

  output        debug_mode,                                /* in debug mode                */
  output        ser_clk,                                   /* serial clk output (cks mode) */
  output        ser_txd,                                   /* transmit data output         */
  output        wfi_state,                                 /* waiting for interrupt        */
  output [15:0] port0_reg,                                 /* port 0                       */
  output [15:0] port1_reg,                                 /* port 1                       */
  output [15:0] port2_reg,                                 /* port 2                       */
  output [15:0] port3_reg,                                 /* port 3                       */

  input         aux_uart_rx                                /* auxiliary UART receive pin   */
);

logic           aux_uart_rx_b;

//assign aux_uart_rx_b  = aux_uart_rx | port2_reg[15];

yrv_mcu yrv_mcu
(
  .clk,                                      
  .ei_req,                                   
  .nmi_req,                                  
  .resetb           (   resetn  ),                                   
  .ser_rxd,                                  
  .port4_in,                                 
  .port5_in,                                 

  .debug_mode,                               
  .ser_clk,                                  
  .ser_txd,                                  
  .wfi_state,                                
  .port0_reg,                                
  .port1_reg,                                
  .port2_reg,                                
  .port3_reg,                                

  //.aux_uart_rx      (  aux_uart_rx_b )                               
  .aux_uart_rx
);


endmodule

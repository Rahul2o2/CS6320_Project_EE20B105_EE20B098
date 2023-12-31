//
// Generated by Bluespec Compiler, version 2021.12.1 (build fd501401)
//
// On Mon Dec 11 14:07:18 IST 2023
//
//
// Ports:
// Name                         I/O  size props
// RDY_cf8152                     O     1 const
// receive                        O     8 reg
// RDY_receive                    O     1 const
// CLK                            I     1 clock
// RST_N                          I     1 reset
// cf8152_fp32                    I    32 reg
// EN_cf8152                      I     1
//
// No combinational paths from inputs to outputs
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkFP32tocf8152(CLK,
		      RST_N,

		      cf8152_fp32,
		      EN_cf8152,
		      RDY_cf8152,

		      receive,
		      RDY_receive);
  input  CLK;
  input  RST_N;

  // action method cf8152
  input  [31 : 0] cf8152_fp32;
  input  EN_cf8152;
  output RDY_cf8152;

  // value method receive
  output [7 : 0] receive;
  output RDY_receive;

  // signals for module outputs
  wire [7 : 0] receive;
  wire RDY_cf8152, RDY_receive;

  // register bias
  reg [7 : 0] bias;
  wire [7 : 0] bias$D_IN;
  wire bias$EN;

  // register cf16op
  reg [7 : 0] cf16op;
  wire [7 : 0] cf16op$D_IN;
  wire cf16op$EN;

  // register exp_i
  reg [7 : 0] exp_i;
  wire [7 : 0] exp_i$D_IN;
  wire exp_i$EN;

  // register exp_o
  reg [7 : 0] exp_o;
  wire [7 : 0] exp_o$D_IN;
  wire exp_o$EN;

  // register fp32inp
  reg [31 : 0] fp32inp;
  wire [31 : 0] fp32inp$D_IN;
  wire fp32inp$EN;

  // register m_i
  reg [22 : 0] m_i;
  wire [22 : 0] m_i$D_IN;
  wire m_i$EN;

  // register m_o
  reg [1 : 0] m_o;
  wire [1 : 0] m_o$D_IN;
  wire m_o$EN;

  // register sb_i
  reg [1 : 0] sb_i;
  wire [1 : 0] sb_i$D_IN;
  wire sb_i$EN;

  // register sb_o
  reg [1 : 0] sb_o;
  wire [1 : 0] sb_o$D_IN;
  wire sb_o$EN;

  // remaining internal signals
  wire [7 : 0] x__h769, x__h796, x__h860, x__h864, y__h715, y__h743;
  wire [1 : 0] x__h415;
  wire exp_i_6_ULE_0b10011110_MINUS_bias_7_1___d22,
       exp_i_6_ULT_0b10000000_MINUS_bias_7_8___d19;

  // action method cf8152
  assign RDY_cf8152 = 1'd1 ;

  // value method receive
  assign receive = cf16op ;
  assign RDY_receive = 1'd1 ;

  // register bias
  assign bias$D_IN =
	     exp_i_6_ULT_0b10000000_MINUS_bias_7_8___d19 ?
	       x__h769 :
	       (exp_i_6_ULE_0b10011110_MINUS_bias_7_1___d22 ?
		  bias :
		  x__h796) ;
  assign bias$EN = 1'd1 ;

  // register cf16op
  assign cf16op$D_IN = { sb_o[0], exp_o[4:0], m_o } ;
  assign cf16op$EN = 1'd1 ;

  // register exp_i
  assign exp_i$D_IN =
	     (fp32inp[30:23] > 8'b10011110 || fp32inp[30:23] < 8'b01000001) ?
	       8'b0 :
	       fp32inp[30:23] ;
  assign exp_i$EN = 1'd1 ;

  // register exp_o
  assign exp_o$D_IN =
	     exp_i_6_ULT_0b10000000_MINUS_bias_7_8___d19 ?
	       8'b0 :
	       (exp_i_6_ULE_0b10011110_MINUS_bias_7_1___d22 ?
		  x__h860 :
		  8'b00011111) ;
  assign exp_o$EN = 1'd1 ;

  // register fp32inp
  assign fp32inp$D_IN = cf8152_fp32 ;
  assign fp32inp$EN = EN_cf8152 ;

  // register m_i
  assign m_i$D_IN =
	     (fp32inp[30:23] > 8'b10011110 || fp32inp[30:23] < 8'b01000001) ?
	       23'b0 :
	       fp32inp[22:0] ;
  assign m_i$EN = 1'd1 ;

  // register m_o
  assign m_o$D_IN = m_i[22:21] ;
  assign m_o$EN = 1'd1 ;

  // register sb_i
  assign sb_i$D_IN =
	     (fp32inp[30:23] > 8'b10011110 || fp32inp[30:23] < 8'b01000001) ?
	       2'b10 :
	       x__h415 ;
  assign sb_i$EN = 1'd1 ;

  // register sb_o
  assign sb_o$D_IN = sb_i ;
  assign sb_o$EN = 1'd1 ;

  // remaining internal signals
  assign exp_i_6_ULE_0b10011110_MINUS_bias_7_1___d22 = exp_i <= y__h743 ;
  assign exp_i_6_ULT_0b10000000_MINUS_bias_7_8___d19 = exp_i < y__h715 ;
  assign x__h415 = { 1'd0, fp32inp[31] } ;
  assign x__h769 = 8'b10000000 - exp_i ;
  assign x__h796 = 8'b10011110 - exp_i ;
  assign x__h860 = x__h864 + bias ;
  assign x__h864 = exp_i - 8'b01111111 ;
  assign y__h715 = 8'b10000000 - bias ;
  assign y__h743 = 8'b10011110 - bias ;

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        bias <= `BSV_ASSIGNMENT_DELAY 8'b00011111;
	cf16op <= `BSV_ASSIGNMENT_DELAY 8'd0;
	exp_i <= `BSV_ASSIGNMENT_DELAY 8'd0;
	exp_o <= `BSV_ASSIGNMENT_DELAY 8'd0;
	fp32inp <= `BSV_ASSIGNMENT_DELAY 32'b01000000000000000000000000000000;
	m_i <= `BSV_ASSIGNMENT_DELAY 23'd0;
	m_o <= `BSV_ASSIGNMENT_DELAY 2'd0;
	sb_i <= `BSV_ASSIGNMENT_DELAY 2'd0;
	sb_o <= `BSV_ASSIGNMENT_DELAY 2'd0;
      end
    else
      begin
        if (bias$EN) bias <= `BSV_ASSIGNMENT_DELAY bias$D_IN;
	if (cf16op$EN) cf16op <= `BSV_ASSIGNMENT_DELAY cf16op$D_IN;
	if (exp_i$EN) exp_i <= `BSV_ASSIGNMENT_DELAY exp_i$D_IN;
	if (exp_o$EN) exp_o <= `BSV_ASSIGNMENT_DELAY exp_o$D_IN;
	if (fp32inp$EN) fp32inp <= `BSV_ASSIGNMENT_DELAY fp32inp$D_IN;
	if (m_i$EN) m_i <= `BSV_ASSIGNMENT_DELAY m_i$D_IN;
	if (m_o$EN) m_o <= `BSV_ASSIGNMENT_DELAY m_o$D_IN;
	if (sb_i$EN) sb_i <= `BSV_ASSIGNMENT_DELAY sb_i$D_IN;
	if (sb_o$EN) sb_o <= `BSV_ASSIGNMENT_DELAY sb_o$D_IN;
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    bias = 8'hAA;
    cf16op = 8'hAA;
    exp_i = 8'hAA;
    exp_o = 8'hAA;
    fp32inp = 32'hAAAAAAAA;
    m_i = 23'h2AAAAA;
    m_o = 2'h2;
    sb_i = 2'h2;
    sb_o = 2'h2;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    if (RST_N != `BSV_RESET_VALUE)
      if (sb_o[1]) $display("Error: Out of range of cfloat8152");
    if (RST_N != `BSV_RESET_VALUE)
      if (!sb_o[1])
	$display("Cfloat8152 representation is: %b and the bias is: %b",
		 cf16op,
		 bias[5:0]);
  end
  // synopsys translate_on
endmodule  // mkFP32tocf8152


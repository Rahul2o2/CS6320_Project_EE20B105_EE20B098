//
// Generated by Bluespec Compiler, version 2021.12.1 (build fd501401)
//
// On Sun Dec 10 11:19:19 IST 2023
//
//
// Ports:
// Name                         I/O  size props
// cf8152tofp                     O    32
// RDY_cf8152tofp                 O     1 const
// CLK                            I     1 unused
// RST_N                          I     1 unused
// cf8152tofp_cf8152              I     8
// cf8152tofp_bias                I     6
//
// Combinational paths from inputs to outputs:
//   (cf8152tofp_cf8152, cf8152tofp_bias) -> cf8152tofp
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

module mkcf8152toFP32(CLK,
		      RST_N,

		      cf8152tofp_cf8152,
		      cf8152tofp_bias,
		      cf8152tofp,
		      RDY_cf8152tofp);
  input  CLK;
  input  RST_N;

  // value method cf8152tofp
  input  [7 : 0] cf8152tofp_cf8152;
  input  [5 : 0] cf8152tofp_bias;
  output [31 : 0] cf8152tofp;
  output RDY_cf8152tofp;

  // signals for module outputs
  wire [31 : 0] cf8152tofp;
  wire RDY_cf8152tofp;

  // remaining internal signals
  wire [7 : 0] x__h65, y__h66, y__h67;

  // value method cf8152tofp
  assign cf8152tofp =
	     { cf8152tofp_cf8152[7],
	       x__h65 + y__h66,
	       cf8152tofp_cf8152[1:0],
	       21'b0 } ;
  assign RDY_cf8152tofp = 1'd1 ;

  // remaining internal signals
  assign x__h65 = 8'b01111111 - y__h67 ;
  assign y__h66 = { 3'b0, cf8152tofp_cf8152[6:2] } ;
  assign y__h67 = { 2'b0, cf8152tofp_bias } ;
endmodule  // mkcf8152toFP32


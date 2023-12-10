package FP32toBF16;

interface Ifc_type;
	method Bit#(16) bf16(Bit#(32) fp32);
endinterface

(*synthesize*)
module mkFP32toBF16 (Ifc_type);
	
	/*Conversion logic:
	  1 sign bit and 8 exponent bits are same
	  mantissa is truncated from 23bits to 7bits		*/
	method Bit#(16) bf16(Bit#(32) fp32);
		return fp32[31:16];
	endmethod

endmodule

endpackage

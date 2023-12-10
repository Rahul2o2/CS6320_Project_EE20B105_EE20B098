package BF16toFP32;

interface Ifc_type;
	method Bit#(32) fp32(Bit#(16) bf16);
endinterface

(*synthesize*)
module mkBF16toFP32 (Ifc_type);
	
	/*Conversion logic:
	  1 sign bit and 8 exponent bits are same
	  mantissa is zero-padded from 7bits to 23bits		*/
	method Bit#(32) fp32(Bit#(16) bf16);
		return {bf16,16'b0};
	endmethod

endmodule

endpackage

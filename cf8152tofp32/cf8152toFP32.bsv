package cf8152toFP32;

interface Ifc_type;
	method Bit#(32) cf8152tofp(Bit#(8) cf8152, Bit#(6)bias);
endinterface

module mkcf8152toFP32 (Ifc_type);
	
	method Bit#(32) cf8152tofp(Bit#(8) cf8152,Bit#(6) bias);
		return {cf8152[7],(8'b01111111 - {2'b0,bias} + {3'b0,cf8152[6:2]}),({cf8152[1:0],21'b0})};
	endmethod
	
endmodule
endpackage

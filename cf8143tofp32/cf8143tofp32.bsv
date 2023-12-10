package cf8143tofp32;


interface Ifc_type;
	method Bit#(32) cf8143tofp(Bit#(8) cf8143, Bit#(6)bias);
endinterface

module mkCF8143toFP32 (Ifc_type);
	
	method Bit#(32) cf8143tofp(Bit#(8) cf8143,Bit#(6) bias);
		return {cf8143[7],(8'b01111111 - {2'b0,bias} + {4'b0,cf8143[6:3]}),({cf8143[2:0],20'b0})};
	endmethod
	
endmodule
endpackage

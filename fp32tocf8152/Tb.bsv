package Tb;

import FP32tocf8152 :: *;
(*synthesize*)
module mkTb (Empty);

	Reg#(Bit#(32)) fp32inp <- mkReg(0); //32bit register which is the FP32 input
	Reg#(Bit#(32)) fp32Array[10];	    //array of inputs to be converted
	Reg#(int) n <- mkReg(0);	    //No. of inputs
	
	//Setting the values to be converted
	fp32Array[0]<-mkReg(32'b01111111010010000000000000000000);		
	fp32Array[1]<-mkReg(32'b11111100101010111010100111111001);
	fp32Array[2]<-mkReg(32'b00101110101010111010100111111001);
	fp32Array[3]<-mkReg(32'b01101110111000111010100111111001);
	fp32Array[4]<-mkReg(32'b11111110101010111010100111111001);
	fp32Array[5]<-mkReg(32'b00001110001010111010100111111001);
	fp32Array[6]<-mkReg(32'b00101110000010111010100111111001);
	fp32Array[7]<-mkReg(32'b10101010101010111010100111111001);
	fp32Array[8]<-mkReg(32'b00101010101010111010100111111001);
	fp32Array[9]<-mkReg(32'b01000000110010000000000000000000);
	//Creating an Instance of the interface
	Ifc_type convert_inst <- mkFP32toCF8152;
	
	//sets the first value 
	rule starter(n<=0);
		fp32inp<=fp32Array[n];
		n<=n+1;
	endrule
	//This rule fires 10 times to convert each input
	rule convert (n<10&&n>0);
		fp32inp<=fp32Array[n];
		convert_inst.cf8152(fp32inp);
		n<=n+1;
	endrule
	
	//Extra cycles added to accomodate pipelining
	rule done (n >= 10&&n<=13);
		convert_inst.cf8152(fp32inp);
		n<=n+1;
	endrule
	//Exits
	rule done2(n>13);
		$finish(0);
	endrule	
	
endmodule

endpackage

package Tb;

import BF16toFP32 :: *;

(*synthesize*)
module mkTb (Empty);

     

	Reg#(Bit#(16)) bf16inp <- mkReg(0); //16bit register which is the bf16 input
	Reg#(Bit#(16)) bf16Array[10];	    //array of inputs to be converted
	Reg#(int) n <- mkReg(0);	    //No. of inputs
	
	//Setting the values to be converted
	bf16Array[0]<-mkReg(16'b1110111010101011);
	bf16Array[1]<-mkReg(16'b1111110010101011);	
	bf16Array[2]<-mkReg(16'b0010111010101011);	
	bf16Array[3]<-mkReg(16'b0110111011100011);	
	bf16Array[4]<-mkReg(16'b1111111010101011);	
	bf16Array[5]<-mkReg(16'b0000111000101011);	
	bf16Array[6]<-mkReg(16'b0010111000001011);	
	bf16Array[7]<-mkReg(16'b1010101010101011);	
	bf16Array[8]<-mkReg(16'b0010101010101011);	
	bf16Array[9]<-mkReg(16'b1011001100110011);	

	//Creating an Instance of the interface
	Ifc_type convert_inst <- mkBF16toFP32;
	
	//sets the first value 
	rule starter(n<=0);
		bf16inp<=bf16Array[n];
		n<=n+1;
	endrule
	//This rule fires 10 times to convert each input
	rule convert (n<10&&n>0);
		bf16inp<=bf16Array[n];
		Bit#(32) fp32out=convert_inst.fp32(bf16inp);
		n<=n+1;
	$display("bf16Representation: %b, fp32 Representation: %b",bf16inp,fp32out);
	endrule
	
	//Exit when all inputs are converted
	rule done (n >= 10);
	Bit#(32) fp32out=convert_inst.fp32(bf16inp);
	n<=n+1;
	$display("bf16Representation: %b, fp32 Representation: %b",bf16inp,fp32out);
	$finish (0);
	endrule
endmodule

endpackage

package cf8143tofp32;

(*synthesize*)
module mkTb (Empty);
	Reg#(Bit#(8)) cf8143inp <- mkReg(0); //8bit register which is the cf8143 input
	Reg#(Bit#(6)) biasinp <- mkReg(0);   //configurable bias is another input
	
	Reg#(Bit#(8)) cf8143Array[10];	    //array of inputs to be converted
	Reg#(Bit#(6)) biasArray[10];	    //array of biases corresponding to each input
	Reg#(int) n <- mkReg(0);	    //No. of inputs
	
	//Example values to be converted along with biases
	cf8143Array[0]<-mkReg(8'b01111111);
	biasArray[0]<-mkReg(6'b010101);		
	
	cf8143Array[1]<-mkReg(8'b11111100);
	biasArray[1]<-mkReg(6'b010101);	
	
	cf8143Array[2]<-mkReg(8'b00101110);
	biasArray[2]<-mkReg(6'b010101);	
	
	cf8143Array[3]<-mkReg(8'b01101110);
	biasArray[3]<-mkReg(6'b110111);	
	
	cf8143Array[4]<-mkReg(8'b11111110);
	biasArray[0]<-mkReg(6'b010000);	
	
	cf8143Array[5]<-mkReg(8'b00001110);
	biasArray[5]<-mkReg(6'b000101);	
	
	cf8143Array[6]<-mkReg(8'b00101110);
	biasArray[6]<-mkReg(6'b000101);	
	
	cf8143Array[7]<-mkReg(8'b10101010);
	biasArray[7]<-mkReg(6'b000001);	
	
	cf8143Array[8]<-mkReg(8'b00101010);
	biasArray[8]<-mkReg(6'b000000);	
	
	cf8143Array[9]<-mkReg(8'b01000000);
	biasArray[9]<-mkReg(6'b011111);	
	
	//Creating an Instance of the interface
	Ifc_type convert_inst <- mkCF8143toFP32;
	
	//sets the first value(without this the execution will start with default value 0) 
	rule starter(n<=0);
		cf8143inp<=cf8143Array[n];
		biasinp<=biasArray[n];
		n<=n+1;
	endrule
	
	//This rule fires 10 times to convert each input
	rule convert (n<=10&&n>0);
		cf8143inp<=cf8143Array[n];
		biasinp<=biasArray[n];
		$display("FP32 representation is: %b", convert_inst.cf8143tofp(cf8143inp,biasinp));
		n<=n+1;
	endrule
	
	//Extra cycles provided to accomodate pipelining
	rule done (n > 10);
		n<=n+1;
		$finish(0);
	endrule
	
endmodule

interface Ifc_type;
	method Bit#(32) cf8143tofp(Bit#(8) cf8143, Bit#(6)bias);
endinterface

module mkCF8143toFP32 (Ifc_type);
	
	method Bit#(32) cf8143tofp(Bit#(8) cf8143,Bit#(6) bias);
		return {cf8143[7],(8'b01111111 - {2'b0,bias} + {4'b0,cf8143[6:3]}),({cf8143[2:0],20'b0})};
	endmethod
	
endmodule
endpackage

package FP32toCF8143;

(*synthesize*)
module mkTb (Empty);

	Reg#(Bit#(32)) fp32inp <- mkReg(0); //32bit register which is the FP32 input
	Reg#(Bit#(32)) fp32Array[10];       //array of inputs to be converted
	Reg#(int)      n<- mkReg(0); //No. of inputs

	//Setting the values to be converted
	fp32Array[0]<-mkReg(32'b00110000110010000000000000000000);
	fp32Array[1]<-mkReg(32'b10110111101010111010100111111001);
	fp32Array[2]<-mkReg(32'b00101110101010111010100111111001);
	fp32Array[3]<-mkReg(32'b01101110111000111010100111111001);
	fp32Array[4]<-mkReg(32'b11111110101010111010100111111001);
	fp32Array[5]<-mkReg(32'b00001110001010111010100111111001);
	fp32Array[6]<-mkReg(32'b00101110000010111010100111111001);
	fp32Array[7]<-mkReg(32'b10101010101010111010100111111001);
	fp32Array[8]<-mkReg(32'b00101010101010111010100111111001);
	fp32Array[9]<-mkReg(32'b01000000110010000000000000000000);

	//Creating an Instance of the interface
	Ifc_type convert_inst <- mkFP32toCF8143;

	//sets the first value
	rule starter(n<=0);
		fp32inp<=fp32Array[n];
		n<=n+1;
	endrule
	
	//This rule fires 10 times to convert each input
	rule convert (n<10&&n>0);
		
		fp32inp<=fp32Array[n];
		convert_inst.cf8143(fp32inp);
		n<=n+1;

	endrule

	//This rule fires to convert the numbers in the pipleline stage
	rule done(n >= 10&&n<=13);

		convert_inst.cf8143(fp32inp);
		n<=n+1;

	endrule
        
        
        // Exits
	rule donef(n>13);
		
		$finish(0);
	
	endrule

endmodule


interface Ifc_type;

	method Action cf8143(Bit#(32) fp32);

endinterface


(*synthesize*)
module mkFP32toCF8143 (Ifc_type);
	//given a non-zero initial value to prevent pipeline error
	Reg#(Bit#(32)) fp32inp <- mkReg(32'b01000000000000000000000000000000);


	Reg#(Bit#(8)) exp_i <- mkReg(0);
	Reg#(Bit#(2)) sb_i  <- mkReg(0);//sign bit but an extra bit is added to act as flaf for out of range
	Reg#(Bit#(23)) m_i  <-mkReg(0);
	//Pipeline stage 1: checks if the number can be represented in cfloat's smaller range
	rule range_check;
		//out of range, everything is made 0, differs from number 0 due to the flag in sign-bit
		if(fp32inp[30:23]>8'b10001110||fp32inp[30:23]<8'b01000001)
		begin		
			exp_i<=8'b0;
			sb_i<=2'b10;
			m_i<=23'b0;
		end
		//If in range: extract the sign, exponent and mantissa
		else
		begin
			exp_i<=fp32inp[30:23];
			sb_i<={0,fp32inp[31]};
			m_i<=fp32inp[22:0];
		end
	
	endrule

	Reg#(Bit#(8)) bias <- mkReg(8'b00011111);
	Reg#(Bit#(8)) exp_o <- mkReg(0);
	Reg#(Bit#(2)) sb_o <- mkReg(0);
	Reg#(Bit#(3)) m_o <-mkReg(0);

//Pipeline stage : assigns exponent, sign bit and mantissa output 
	rule setOp;
		sb_o<=sb_i;
		m_o<=m_i[22:20];	//truncating
		//Setting the bias: we start with a default bias of 31
		//if exponent cannot be represented using that bias, we assign the new bias	
		if(exp_i<(8'b10000000-bias))
		begin		
			bias<=8'b10000000-exp_i;
			exp_o<=8'b0;
		end
	
		else if(exp_i>8'b10001110 -bias)
		begin
			bias<=8'b10001110-exp_i;
			exp_o<=8'b00001111;
		end
		
		else
		begin
			bias<=bias;
			exp_o<=exp_i-8'b01111111+bias;
		end
	
	endrule
		//Concatenate to get final result
	rule dispOut;

		Bit#(8) cf16op={sb_o[0],exp_o[3:0],m_o};

		if(sb_o[1]!=1'b0)
		begin
			$display("Error: Out of range of cfloat8152");
		end

		else
		begin
			$display("Cfloat8143 representation is: %b and the bias is: %b",cf16op, bias[5:0]);
		end
	endrule

	method Action cf8143(Bit#(32) fp32);
		fp32inp <= fp32;
	endmethod
endmodule
endpackage

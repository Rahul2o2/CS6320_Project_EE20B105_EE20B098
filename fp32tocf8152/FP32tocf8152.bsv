package FP32tocf8152;


interface Ifc_type;
	method Action cf8152(Bit#(32) fp32);
endinterface

(*synthesize*)
module mkFP32tocf8152 (Ifc_type);
	
	//given a non-zero initial value to prevent pipeline error
	Reg#(Bit#(32)) fp32inp <- mkReg(32'b01000000000000000000000000000000);
	
	Reg#(Bit#(8)) exp_i <- mkReg(0);
	Reg#(Bit#(2)) sb_i <- mkReg(0);//sign bit but an extra bit is added to act as flaf for out of range
	Reg#(Bit#(23)) m_i <-mkReg(0);
	
	//Pipeline stage 1: checks if the number can be represented in cfloat's smaller range
	rule range_check;
	if(fp32inp[30:23]>8'b10011110||fp32inp[30:23]<8'b01000001)
	begin
	//out of range, everything is made 0, differs from number 0 due to the flag in sign-bit
		exp_i<=8'b0;
		sb_i<=2'b10;
		m_i<=23'b0;
	end	
	else
	begin
	//If in range: extract the sign, exponent and mantissa
		exp_i<=fp32inp[30:23];
		sb_i<={0,fp32inp[31]};
		m_i<=fp32inp[22:0];			
	end
	endrule
	
	Reg#(Bit#(8)) bias <- mkReg(8'b00011111);
	Reg#(Bit#(8)) exp_o <- mkReg(0);
	Reg#(Bit#(2)) sb_o <- mkReg(0);
	Reg#(Bit#(2)) m_o <-mkReg(0);

	//Pipeline stage : assigns exponent, sign bit and mantissa output 
	rule setOp;
	sb_o<=sb_i;		
	m_o<=m_i[22:21];	//truncating
		
	//Setting the bias: we start with a default bias of 31
	//if exponent cannot be represented using that bias, we assign the new bias
	if(exp_i<(8'b10000000-bias))
		begin
			bias<=8'b10000000-exp_i;
			exp_o<=8'b0;		
		end
		else if(exp_i>8'b10011110 -bias)
		begin
			bias<=8'b10011110-exp_i;
			exp_o<=8'b00011111;
		end
		else
		begin
			bias<=bias;
			exp_o<=exp_i-8'b01111111+bias;
		end	
	endrule
	
	//Concatenate to get final result
	rule dispOut;
		Bit#(8) cf16op={sb_o[0],exp_o[4:0],m_o};
		if(sb_o[1]!=1'b0)
		begin
			$display("Error: Out of range of cfloat8152");
		end
		else
		begin	
			$display("Cfloat8152 representation is: %b and the bias is: %b",cf16op, bias[5:0]);
		end
	endrule
	
	method Action cf8152(Bit#(32) fp32);
		fp32inp <= fp32;
	endmethod
endmodule
endpackage

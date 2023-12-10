# Pipelined Convertor modules 

Area-efficient pipelined converter modules from fp32 datatype to the following datatypes and vice-versa : bfloat16 , cfloat8_1_5_2 , cfloat8_1_4_3 

## Table of Contents

- [Overview](#overview)
- [Design Decisions](#design-decisions)
- [Verification Methodology](#verification-methodology)
- [Usage](#usage)


## Overview
The project aims to develop area-efficient pipelined converter modules that facilitate the conversion between the IEEE 754 32-bit floating-point (fp32) data type and three specific alternative data types: bfloat16, cfloat8_1_5_2, and cfloat8_1_4_3. The target data types—bfloat16, cfloat8_1_5_2, and cfloat8_1_4_3—represent different formats with varied precision and storage characteristics compared to the standard 32-bit floating-point representation. 

## Design Decisions

The initial design decision centered around the pipeline architecture. We deliberated on whether the data should be presented as instructions requiring fetching, decoding to ascertain the conversion type and inputs, followed by distinct execute and write-out stages. However, we proceeded with the case where each module could be independently accessed, allowing for a pipelined conversion process.

The next design decision came with regard to the conversion process. When converting from a higher precision to a lower precision, we were presented with a choice of rounding off or truncating the mantissa. Through analysis, we determined that truncation would result in less data loss compared to rounding off.

For instance, consider the number 1.10011, and let's say we aim to convert it to a 4-bit mantissa.

- **Choice 1: Truncating** - Result: 1.1001 (Data reduced by 2<sup>-5</sup>)
- **Choice 2: Rounding off** - Result: 1.1010 (Data increased by 2<sup>-4</sup>)
  - **Choice 1: Truncating** - Result: 1.1001 (Data reduced by \(2^{-5}\))
- **Choice 2: Rounding off** - Result: 1.1010 (Data increased by \(2^{-4}\))
If the last bit was 0, both rounding off and truncation would yield the same result. Consequently, we chose truncation.

 Our next hurdle came when we had to decide on the conversion process tfrom fp32 to cfloat. Mantissa could be truncated easily, while exponent proved to be a challenge. We had two things to control the 5 exponent bits and a6-bit bias. We deliberated for a while and finally decided on the following:
 First we would check if the exponent was not out of range to be represented in cfloat since it had only 5 or 4 exponent bits. Then we started with a bias of 31 as a starting point. Since the nature of application of cfloat was for neural networks, we figured that numbers would be similar in magnitude and would not require a change in bias frequently. 

![image](https://github.com/Rahul2o2/CS6320_Project_EE20B105_EE20B098/assets/87159544/f39be51c-a215-491b-a65c-3a28204888be)



Our final decision was to forgo pipelining in few simple modules like converting from fp32 to bf16 as it required a simple truncating of mantissa and the pipeling overhead that would be introduced would make the module less efficient.

## Verification Methodology

We were faced with the decision on how to provide the inputs through testbench. We needed multiple inputs to be passed since we would be pipelining it . We unsuccessfuly tried writing a code for the test bench to read 32-bit inputs froma a file, but this was not supported well by bluespec unlike verilog.

	// Open the file and check for proper opening
		String readFile = "test.txt" ;
		File lfh <- $fopen( readFile, "r" ) ;
	    for (int i = 0; i < 9; i = i + 1) begin
      int value <- $fgetc(lfh);
      if (value != -1) begin
        data[i] <= pack((value));
      end else begin
        $display("Error reading value from %s", readFile);
      end
    end
	$fclose ( lfh ) ;

Then we proceeded to just stick with an array of registers initialised with the value to be tested. Each module was thoroughly tested for bugs and simulated through testbench.
One note of caution with the pipelined module is that the user has to wait for 4 cycles  after which the first data would come out through the pipeline and would output a new data each cycle then on.

## Usage
We have 6 folders each corresponding to a conversion module as indicated by the title. Each contains the bluespec module  bsv code and a testbench to simulate. We have also provided the bluespec code converted to verilog which was used for area estimation in our synthesis tool.

## Steps to execute the code

Run the following commands in the terminal by giving converter module filename and test bench file name.

To run the module:

```bsc -sim -g mkmodulename filename.bsv```

To run the Test bench:

```bsc -sim -e mkTb -o ./mkTb_bsim```
```./mkTb_bsim```






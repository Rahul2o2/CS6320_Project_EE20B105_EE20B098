# Pipelined Convertor modules 

Area-efficient pipelined converter modules from fp32 datatype to the following datatypes and vice-versa : bfloat16 , cfloat8_1_5_2 , cfloat8_1_4_3 

## Table of Contents

- [Overview](#overview)
- [Design Decisions](#design-decisions)
- [Verification Methodology](#verification-methodology)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

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

Our next decision 

## Verification Methodology

Describe the methodology used to verify the correctness and reliability of your project. This could involve testing procedures, code reviews, and other quality assurance practices.

## Installation

Provide step-by-step instructions on how to install and set up your project. Include any dependencies that need to be installed.

## Usage

Explain how to use your project. Provide examples and screenshots if possible. Include any configuration options or special considerations for users.

## Contributing

If you want others to contribute to your project, provide guidelines for them. Include information about how to submit issues or pull requests. Describe the coding standards and any contribution workflows.

## License

Specify the license under which your project is distributed. For example, you can use [MIT License](https://opensource.org/licenses/MIT).


# Math Operations Sample

## Description

Demonstrates NeoCore's mathematical functions and fixed-point arithmetic operations.

## Features Demonstrated

- **Fixed-Point Arithmetic**: Working with decimal numbers on integer-only hardware
- **Bitwise Operations**: Fast multiplication and division using bit shifting
- **Utility Functions**: Min, max, and absolute value operations

## Key Functions Used

- `nc_fix()` - Convert floating-point to fixed-point format
- `nc_fix_to_int()` - Convert fixed-point back to integer
- `nc_fix_add()` - Add two fixed-point numbers
- `nc_bitwise_multiplication_2()` - Fast multiplication by 2 (bit shift left)
- `nc_bitwise_multiplication_4()` - Fast multiplication by 4 (bit shift left)
- `nc_bitwise_division_4()` - Fast division by 4 (bit shift right)
- `nc_min()` - Return minimum of two values
- `nc_max()` - Return maximum of two values
- `nc_abs()` - Return absolute value

## What You'll See

Console output displaying results of various mathematical operations:
- `10.5 ADD 10.5 : 21` - Fixed-point addition
- `11 MULT 2 : 22` - Bitwise multiplication by 2
- `11 MULT 4 : 44` - Bitwise multiplication by 4
- `40 DIV 4 : 10` - Bitwise division by 4
- `MIN 15, 20 : 15` - Minimum value selection
- `MAX 15, 20 : 20` - Maximum value selection
- `ABS -11: 11` - Absolute value calculation

## Technical Details

### Fixed-Point Arithmetic
- Neo Geo hardware doesn't have floating-point unit
- Fixed-point format allows decimal arithmetic using integers
- `nc_fix(10.5)` converts 10.5 to internal fixed-point representation

### Bitwise Operations
- **Multiplication by 2**: Left shift by 1 bit (`x << 1`)
- **Multiplication by 4**: Left shift by 2 bits (`x << 2`)
- **Division by 4**: Right shift by 2 bits (`x >> 2`)
- These operations are much faster than traditional multiplication/division

## Learning Objectives

This sample teaches:
- How to work with decimal numbers on integer-only hardware
- Understanding fixed-point arithmetic representation
- Using fast bitwise operations for power-of-2 multiplication/division
- Essential mathematical utilities for game development
- Performance optimization through appropriate math function selection

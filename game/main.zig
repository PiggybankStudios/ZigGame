//  File:   main.zig
//  Author: Taylor Robbins
//  Date:   12\15\2024
//  Description: 
//  	** Holds the main entry pointer for the game portion of the codebase

pub fn main() void
{
	print("Hello World!\n", .{});
}

const std = @import("std");
const print = std.debug.print;

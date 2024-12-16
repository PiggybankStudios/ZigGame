//  File:   build.zig
//  Author: Taylor Robbins
//  Date:   12\15\2024
//  Description: 
//  	** Contains the main build script for the application. The result of the build is written to the build/ folder

pub fn build(b: *std.Build) void
{
	b.release_mode = .safe;
	
	b.dest_dir = "build";
	b.exe_dir = "build";
	b.lib_dir = "build";
	
	const exe = b.addExecutable(.{
		.name = "Game",
		.root_source_file = b.path("game/main.zig"),
		.target = b.host,
		.optimize = .Debug, //.Debug, .ReleaseSafe, .ReleaseFast, .ReleaseSmall
	});
	b.installArtifact(exe);
	
	// use "zig build run" to make this step execute
	const runExe = b.addRunArtifact(exe);
	const runStep = b.step("run", "Run the game");
	runStep.dependOn(&runExe.step);
}

const std = @import("std");

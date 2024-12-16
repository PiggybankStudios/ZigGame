//  File:   main.zig
//  Author: Taylor Robbins
//  Date:   12\15\2024
//  Description: 
//  	** Holds the main entry pointer for the game portion of the codebase

/// Default GLFW error handling callback
fn errorCallback(error_code: glfw.ErrorCode, description: [:0]const u8) void
{
	std.log.err("glfw: {}: {s}\n", .{ error_code, description });
}

const Window = struct
{
	allocator: Allocator,
	glfwWindow: glfw.Window,
	nameNt: [:0]u8 = undefined,
	name: []u8 = "",
	
	fn destroy(self: *Window) void
	{
		if (self.name.len > 0)
		{
			self.allocator.free(self.nameNt);
			self.name = "";
		}
		self.glfwWindow.destroy();
	}
	fn setName(self: *Window, newName: []const u8) !void
	{
		if (self.name.len > 0)
		{
			self.allocator.free(self.nameNt);
			self.name = "";
		}
		if (newName.len > 0)
		{
			const newSpace = try self.allocator.alloc(u8, newName.len+1);
			@memcpy(newSpace[0..newName.len], newName);
			newSpace[newName.len] = 0;
			self.nameNt = newSpace[0..newName.len :0];
			self.name = newSpace[0..newName.len];
		}
		if (self.name.len > 0)
		{
			self.glfwWindow.setTitle(self.nameNt);
		}
	}
};

pub fn main() !void
{
	var stdGpa = std.heap.GeneralPurposeAllocator(.{
		.enable_memory_limit = false,
		.safety = true,
		.thread_safe = false,
		.verbose_log = false,
	}){};
	defer { const deinitResult = stdGpa.deinit(); assert(deinitResult == .ok); }
	const stdAllocator = stdGpa.allocator();
	
	glfw.setErrorCallback(errorCallback);
	if (!glfw.init(.{}))
	{
		std.log.err("failed to initialize GLFW: {?s}", .{glfw.getErrorString()});
		std.process.exit(1);
	}
	defer glfw.terminate();
	
	// Create our window
	const glfwWindow = glfw.Window.create(640, 480, "Hello, mach-glfw!", null, null, .{}) orelse
	{
		std.log.err("failed to create GLFW window: {?s}", .{glfw.getErrorString()});
		std.process.exit(1);
	};
	var window = Window { .allocator = stdAllocator, .glfwWindow = glfwWindow };
	defer window.destroy();
	try window.setName("Zig Game!");
	
	// Wait for the user to close the window.
	while (!window.glfwWindow.shouldClose())
	{
		window.glfwWindow.swapBuffers();
		glfw.pollEvents();
	}
}

const std = @import("std");
const print = std.debug.print;
const assert = std.debug.assert;
const Allocator = std.mem.Allocator;
const glfw = @import("mach-glfw");

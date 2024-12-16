//  File:   main.zig
//  Author: Taylor Robbins
//  Date:   12\15\2024
//  Description: 
//  	** Holds the main entry pointer for the game portion of the codebase

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

/// Default GLFW error handling callback
fn errorCallback(error_code: glfw.ErrorCode, description: [:0]const u8) void
{
	std.log.err("glfw: {}: {s}\n", .{ error_code, description });
}

fn posCallback(window: glfw.Window, xpos: i32, ypos: i32) void
{
	_ = window;
	_ = xpos;
	_ = ypos;
}
fn sizeCallback(window: glfw.Window, width: i32, height: i32) void
{
	_ = window;
	_ = width;
	_ = height;
}
fn closeCallback(window: glfw.Window) void
{
	_ = window;
}
fn refreshCallback(window: glfw.Window) void
{
	_ = window;
}
fn focusCallback(window: glfw.Window, focused: bool) void
{
	_ = window;
	_ = focused;
}
fn iconifyCallback(window: glfw.Window, iconified: bool) void
{
	_ = window;
	_ = iconified;
}
fn maximizeCallback(window: glfw.Window, maximized: bool) void
{
	_ = window;
	_ = maximized;
}
fn framebufferSizeCallback(window: glfw.Window, width: u32, height: u32) void
{
	_ = window;
	_ = width;
	_ = height;
}
fn contentScaleCallback(window: glfw.Window, xscale: f32, yscale: f32) void
{
	_ = window;
	_ = xscale;
	_ = yscale;
}

pub fn main() !void
{
	var stdGpa = std.heap.GeneralPurposeAllocator(.{
		.enable_memory_limit = false,
		.safety = true,
		.thread_safe = false,
		.verbose_log = false,
	}){};
	defer
	{
		const deinitResult = stdGpa.deinit();
		assert(deinitResult == .ok);
	}
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
	
	window.glfwWindow.setPosCallback(posCallback);
	window.glfwWindow.setSizeCallback(sizeCallback);
	window.glfwWindow.setCloseCallback(closeCallback);
	window.glfwWindow.setRefreshCallback(refreshCallback);
	window.glfwWindow.setFocusCallback(focusCallback);
	window.glfwWindow.setIconifyCallback(iconifyCallback);
	window.glfwWindow.setMaximizeCallback(maximizeCallback);
	window.glfwWindow.setFramebufferSizeCallback(framebufferSizeCallback);
	window.glfwWindow.setContentScaleCallback(contentScaleCallback);
	
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

//  File:   main.zig
//  Author: Taylor Robbins
//  Date:   12\15\2024
//  Description: 
//  	** Holds the main entry pointer for the game portion of the codebase

const Common = @import("common.zig");
const std = Common.std;
const glfw = Common.glfw;
const print = std.debug.print;
const assert = std.debug.assert;
const Allocator = std.mem.Allocator;

const PlatformState = struct
{
	initialized: bool,
	stdGpa: std.heap.GeneralPurposeAllocator(.{
			.enable_memory_limit = false,
			.safety = true,
			.thread_safe = false,
			.verbose_log = false,
	}),
	stdHeap: *Allocator,
	window: *Common.Window,
};
var Platform: *PlatformState = null;

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
	// +==============================+
	// |    Prepare PlatformState     |
	// +==============================+
	{
		var stdGpa = {};
		const stdAllocator: Allocator = stdGpa.allocator();
		
		Platform = try Common.Helpers.createDefault(PlatformState, stdAllocator);
		
		Platform.stdHeap = stdAllocator;
		
		glfw.setErrorCallback(errorCallback);
		if (!glfw.init(.{}))
		{
			std.log.err("failed to initialize GLFW: {?s}", .{glfw.getErrorString()});
			std.process.exit(1);
		}
		
		
		// Create our window
		var window = Common.Window.create(stdAllocator, 640, 480, "Hello, mach-glfw!") catch |err|
		{
			std.log.err("Failed to create Window: {}", .{err});
			std.process.exit(1);
		};
		
	}
	
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
	
	Platform.stdHeap.destroy(Platform.window);
	Platform.window.destroy();
	glfw.terminate();
	const deinitResult = stdGpa.deinit();
	assert(deinitResult == .ok);
}

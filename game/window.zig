//  File:   Window.zig
//  Author: Taylor Robbins
//  Date:   12\19\2024
//  Description: 
//  	** Holds the Window struct that manages a glfw.Window

const Common = @import("common.zig");

pub const Window = struct
{
	allocator: Common.std.mem.Allocator,
	glfwWindow: Common.glfw.Window,
	nameNt: [:0]u8 = undefined,
	name: []u8 = "",
	
	pub fn create(allocator: Common.std.mem.Allocator, width: u32, height: u32, name: []const u8) !*Window
	{
		const result = try Common.Helpers.createDefault(Window, allocator);
		result.allocator = allocator;
		errdefer result.destroy();
		try result.allocName(name);
		result.glfwWindow = Common.glfw.Window.create(width, height, result.nameNt, null, null, .{}) orelse return error.GlfwCreateWindowFailed;
		return result;
	}
	
	pub fn destroy(self: *Window) void
	{
		if (self.name.len > 0)
		{
			self.allocator.free(self.nameNt);
			self.name = "";
		}
		self.glfwWindow.destroy();
	}
	
	fn allocName(self: *Window, newName: []const u8) !void
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
	}
	pub fn setName(self: *Window, newName: []const u8) !void
	{
		try self.allocName(newName);
		if (self.name.len > 0)
		{
			self.glfwWindow.setTitle(self.nameNt);
		}
	}
};

//  File:   common.zig
//  Author: Taylor Robbins
//  Date:   12\19\2024
//  Description: 
//  	** Holds the common @imports that we do across the project 
//		** Every file in the project should const Common = @import("common.zig")

// +--------------------------------------------------------------+
// |                       Standard Imports                       |
// +--------------------------------------------------------------+
pub const std = @import("std");

// +--------------------------------------------------------------+
// |                       Library Imports                        |
// +--------------------------------------------------------------+
pub const glfw = @import("mach-glfw");

// +--------------------------------------------------------------+
// |                         Source Files                         |
// +--------------------------------------------------------------+
pub const Window = @import("window.zig").Window;
pub const Helpers = @import("helpers.zig");

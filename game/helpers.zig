
pub fn createDefault(comptime T: type, allocator: std.mem.Allocator) !*T
{
    const result = try allocator.create(T);
    inline for (std.meta.fields(T)) |field|
    {
        if (field.default_value) |defaultValue|
        {
            @field(result, field.name) = @as(*const field.type, @ptrCast(@alignCast(defaultValue))).*;
        }
    }
    return result;
}

const std = @import("std");

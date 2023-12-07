const std = @import("std");
const day1 = @import("day1/day1.zig");
const day2 = @import("day2/day2.zig");

pub fn main() !void {
    // std.debug.print("day1 solution A {d}\n", .{try day1.solA()});
    // std.debug.print("day1 solution B {d}\n", .{try day1.solB()});
    std.debug.print("day2 solution A {d}\n", .{try day2.solA()});
}

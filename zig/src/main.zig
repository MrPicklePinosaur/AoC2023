const std = @import("std");
const day1 = @import("day1/day1.zig");
const day2 = @import("day2/day2.zig");
const day3 = @import("day3/day3.zig");
const day4 = @import("day4/day4.zig");

pub fn main() !void {
    // std.debug.print("day4 solution A {d}\n", .{try day4.solA()});
    std.debug.print("day4 solution B {d}\n", .{try day4.solB()});
}

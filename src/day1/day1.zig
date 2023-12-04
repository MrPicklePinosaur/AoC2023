const std = @import("std");

const Day1Error = error{MissingInput};

pub fn sol() !void {
    // TODO assume we are running from project root
    const file = try std.fs.cwd().openFile("src/day1/input.txt", .{});
    defer file.close();

    while (true) {
        var buffer: [100]u8 = undefined;
        const line = (try file.reader().readUntilDelimiterOrEof(&buffer, '\n')) orelse break;
        std.debug.print("{s}\n", .{line});
    }
}

const std = @import("std");

pub fn solA() !u32 {
    const file = try std.fs.cwd().openFile("src/day2/input.txt", .{});
    defer file.close();

    var tot: u32 = 0;
    var line_num: u32 = 1;
    while (true) {
        var buffer: [256]u8 = undefined;
        const line = (try file.reader().readUntilDelimiterOrEof(&buffer, '\n')) orelse break;

        const trimmed = line[std.mem.indexOf(u8, line, ":").? + 2 ..];
        var valid = true;
        var group_splits = std.mem.split(u8, trimmed, "; ");
        next: while (group_splits.next()) |pull| {
            var color_splits = std.mem.split(u8, pull, ", ");
            while (color_splits.next()) |color| {
                var item_splits = std.mem.split(u8, color, " ");

                const count = try std.fmt.parseUnsigned(u32, item_splits.first(), 10);
                const color_str = item_splits.next().?;
                if ((std.mem.eql(u8, color_str, "red") and count > 12) or (std.mem.eql(u8, color_str, "green") and count > 13) or (std.mem.eql(u8, color_str, "blue") and count > 14)) {
                    valid = false; // TODO ugly flag variable
                    break :next;
                }
            }
        }

        if (valid) {
            tot += line_num;
        }
        line_num += 1;
    }
    return tot;
}

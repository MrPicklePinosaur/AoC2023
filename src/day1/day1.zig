const std = @import("std");

pub fn solA() !u32 {
    // TODO assume we are running from project root
    const file = try std.fs.cwd().openFile("src/day1/input.txt", .{});
    defer file.close();

    var tot: u32 = 0;
    while (true) {
        // TODO assume no utf8
        var buffer: [100]u8 = undefined;
        const line = (try file.reader().readUntilDelimiterOrEof(&buffer, '\n')) orelse break;

        var front_char: ?u8 = null;
        var back_char: ?u8 = null;

        var i: usize = 0;
        while (i < line.len) : (i += 1) {
            const ch = line[i];
            if ('0' <= ch and ch <= '9') {
                front_char = ch - '0';
                break;
            }
        }

        i = 1;
        while (i <= line.len) : (i += 1) {
            const ch = line[line.len - i];
            if ('0' <= ch and ch <= '9') {
                back_char = ch - '0';
                break;
            }
        }

        if (front_char == null or back_char == null) continue;

        tot += front_char.? * 10 + back_char.?;
    }
    return tot;
}

pub fn solB() !u32 {
    const file = try std.fs.cwd().openFile("src/day1/input.txt", .{});
    defer file.close();

    const Mapping = struct { str: []const u8, num: u32 };

    const mapping_table = [_]Mapping{
        Mapping{ .str = "0", .num = 0 },
        Mapping{ .str = "1", .num = 1 },
        Mapping{ .str = "2", .num = 2 },
        Mapping{ .str = "3", .num = 3 },
        Mapping{ .str = "4", .num = 4 },
        Mapping{ .str = "5", .num = 5 },
        Mapping{ .str = "6", .num = 6 },
        Mapping{ .str = "7", .num = 7 },
        Mapping{ .str = "8", .num = 8 },
        Mapping{ .str = "9", .num = 9 },
        Mapping{ .str = "one", .num = 1 },
        Mapping{ .str = "two", .num = 2 },
        Mapping{ .str = "three", .num = 3 },
        Mapping{ .str = "four", .num = 4 },
        Mapping{ .str = "five", .num = 5 },
        Mapping{ .str = "six", .num = 6 },
        Mapping{ .str = "seven", .num = 7 },
        Mapping{ .str = "eight", .num = 8 },
        Mapping{ .str = "nine", .num = 9 },
    };

    var tot: u32 = 0;
    while (true) {
        // TODO assume no utf8
        var buffer: [100]u8 = undefined;
        const line = (try file.reader().readUntilDelimiterOrEof(&buffer, '\n')) orelse break;
        const line_len = line.len;

        var val: u32 = 0;

        var i: usize = 0;
        left_outer: while (i < line_len) : (i += 1) {
            for (mapping_table) |mapping| {
                if (std.mem.eql(u8, line[i..@min(i + mapping.str.len, line_len)], mapping.str)) {
                    // std.debug.print("found {s}\n", .{mapping.str});
                    val += 10 * mapping.num;
                    break :left_outer;
                }
            }
        }

        i = 0;
        right_outer: while (i < line_len) : (i += 1) {
            for (mapping_table) |mapping| {
                if (std.mem.eql(u8, line[line_len -| i -| mapping.str.len .. line_len - i], mapping.str)) {
                    // std.debug.print("found {s}\n", .{mapping.str});
                    val += mapping.num;
                    break :right_outer;
                }
            }
        }
        tot += val;
    }

    return tot;
}

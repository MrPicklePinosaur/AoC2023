const std = @import("std");

const Day1Error = error{
    MissingNum, // line does not have number on it
};

pub fn sol() !u32 {
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

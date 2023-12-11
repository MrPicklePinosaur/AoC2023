const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

pub fn solA() !u32 {
    const file = try std.fs.cwd().openFile("src/day4/input.txt", .{});
    defer file.close();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var winning_nums = std.AutoHashMap(u32, void).init(allocator);

    var tot: u32 = 0;
    while (true) {
        var buffer: [256]u8 = undefined;
        const line = (try file.reader().readUntilDelimiterOrEof(&buffer, '\n')) orelse break;

        winning_nums.clearAndFree();

        const trimmed = line[mem.indexOf(u8, line, ":").? + 2 ..];
        var card_sections = mem.split(u8, trimmed, "|");

        var my_nums_it = mem.tokenize(u8, card_sections.next().?, " ");
        var winning_nums_it = mem.tokenize(u8, card_sections.next().?, " ");

        while (winning_nums_it.next()) |num| {
            try winning_nums.put(try std.fmt.parseInt(u32, num, 10), {});
        }

        var matches: u32 = 0;
        while (my_nums_it.next()) |num| {
            if (winning_nums.get(try std.fmt.parseInt(u32, num, 10)) != null) {
                matches += 1;
            }
        }

        if (matches > 0) {
            tot += std.math.pow(u32, 2, matches -| 1);
        }
    }
    return tot;
}

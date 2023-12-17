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
    defer winning_nums.deinit();

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

pub fn solB() !u32 {
    const file = try std.fs.cwd().openFile("src/day4/input.txt", .{});
    defer file.close();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var winning_nums = std.AutoHashMap(u32, void).init(allocator);
    defer winning_nums.deinit(); // TODO technically not necessary (since we use arena allocator)

    // TODO not best choice of data structure?
    var games = std.ArrayList(u32).init(allocator);

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

        var winning: u32 = 0;
        while (my_nums_it.next()) |num| {
            const num_parsed = try std.fmt.parseInt(u32, num, 10);
            if (winning_nums.get(num_parsed) != null) {
                winning += 1;
            }
        }

        try games.append(winning);
    }

    const num_games = games.items.len;
    var table: []u32 = try allocator.alloc(u32, num_games);
    @memset(table, 1);

    var i: usize = 0;
    while (i < num_games) : (i += 1) {
        const card_num = table[i];
        const winning = games.items[i];
        var j: u32 = 0;
        while (j < winning) : (j += 1) {
            table[i + 1 + j] += card_num;
        }
    }

    var tot: u32 = 0;
    i = 0;
    while (i < num_games) : (i += 1) {
        tot += table[i];
    }

    return tot;
}

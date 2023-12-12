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

fn top_sort(graph: std.ArrayList(std.ArrayList(u32)), allocator: mem.Allocator) !std.ArrayList(u32) {
    const n = graph.items.len;

    var out_stack = std.ArrayList(u32).init(allocator);
    var visited: []bool = try allocator.alloc(bool, n);
    @memset(visited, false);

    var i: u32 = 0;
    while (i < n) : (i += 1) {
        if (visited[i] == false) {
            try _top_sort(graph, visited, &out_stack, i);
        }
    }
    return out_stack;
}

fn _top_sort(graph: std.ArrayList(std.ArrayList(u32)), visited: []bool, out_stack: *std.ArrayList(u32), i: u32) !void {
    const edges = graph.items[i].items;

    visited[i] = true;
    for (edges) |edge| {
        if (visited[edge -| 1] == false) {
            try _top_sort(graph, visited, out_stack, edge -| 1);
        }
    }
    try out_stack.append(i);
}

pub fn solB() !u32 {
    const file = try std.fs.cwd().openFile("src/day4/input_small.txt", .{});
    defer file.close();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var winning_nums = std.AutoHashMap(u32, void).init(allocator);
    defer winning_nums.deinit(); // TODO technically not necessary (since we use arena allocator)

    // TODO not best choice of data structure?
    var games = std.ArrayList(std.ArrayList(u32)).init(allocator);

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

        var matched_nums = std.ArrayList(u32).init(allocator);

        while (my_nums_it.next()) |num| {
            const num_parsed = try std.fmt.parseInt(u32, num, 10);
            if (winning_nums.get(num_parsed) != null) {
                try matched_nums.append(num_parsed);
            }
        }

        try games.append(matched_nums);
    }

    const num_games = games.items.len;
    print("num games {d}\n", .{num_games});
    var table: []u32 = try allocator.alloc(u32, num_games);
    @memset(table, 1);

    for (games.items) |game| {
        for (game.items) |winning_item| {
            print("{d},", .{winning_item});
        }
        print("\n", .{});
    }

    // const sorted = try top_sort(games, allocator);

    // for (sorted.items) |item| {
    //     const card_num = table[item];
    //     const winning = games.items[item].items;
    //     print("[{d}] num {d}: ", .{ item, card_num });
    //     for (winning) |winning_item| {
    //         table[winning_item] += card_num;
    //         print("{d},", .{winning_item});
    //     }
    //     print("\n", .{});
    // }

    // var tot: u32 = 0;
    // var i: usize = 0;
    // while (i < num_games) : (i += 1) {
    //     tot += table[i];
    // }

    // return tot;
    return 0;
}

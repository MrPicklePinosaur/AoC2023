const std = @import("std");
const Tuple = std.meta.Tuple;
const print = std.debug.print;

const Point = Tuple(&.{ usize, usize });
const PartNum = struct {
    num: u32,
    len: usize,
    pos: Point,
};

fn is_part_num(sym_map: std.AutoHashMap(Point, void), part_num: PartNum) bool {
    const d_x = part_num.pos.@"0";
    const d_y = part_num.pos.@"1";

    if (sym_map.get(.{ d_x -| 1, d_y -| 1 }) != null) return true;
    if (sym_map.get(.{ d_x -| 1, d_y }) != null) return true;
    if (sym_map.get(.{ d_x -| 1, d_y + 1 }) != null) return true;

    if (sym_map.get(.{ d_x + part_num.len, d_y -| 1 }) != null) return true;
    if (sym_map.get(.{ d_x + part_num.len, d_y }) != null) return true;
    if (sym_map.get(.{ d_x + part_num.len, d_y + 1 }) != null) return true;

    var i: usize = 0;
    while (i < part_num.len) : (i += 1) {
        if (sym_map.get(.{ d_x + i, d_y -| 1 }) != null) return true;
        if (sym_map.get(.{ d_x + i, d_y + 1 }) != null) return true;
    }

    return false;
}

pub fn solA() !u32 {
    const file = try std.fs.cwd().openFile("src/day3/input.txt", .{});
    defer file.close();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var sym_map = std.AutoHashMap(Point, void).init(allocator);
    var nums_list = std.ArrayList(PartNum).init(allocator);

    var tot: u32 = 0;
    var y: usize = 0;
    while (true) : (y += 1) {
        // TODO read all into memory and make second pass after
        var buffer: [256]u8 = undefined;
        const line = (try file.reader().readUntilDelimiterOrEof(&buffer, '\n')) orelse break;

        const line_len = line.len;
        var x: usize = 0;
        while (x < line_len) : (x += 1) {
            var ch = line[x];

            if (ch == '.') continue;

            if ('0' <= ch and ch <= '9') {
                var i: usize = 0;
                var num: u32 = 0;
                var part_num = PartNum{ .num = 0, .len = 0, .pos = .{ x, y } };
                while ((x < line_len)) : ({
                    x += 1;
                    i += 1;
                }) {
                    ch = line[x];
                    if (!('0' <= ch and ch <= '9')) break;
                    num = num * 10 + (ch - '0');
                }
                // print("got num {d}, len {d}\n", .{ num, i });
                part_num.num = num;
                part_num.len = i;
                try nums_list.append(part_num);

                x = x -| 1; // TODO bad code but this is to avoid double incrementing
                continue;
            }

            // everything else is symbol
            print("{d},{d} {c}\n", .{ x, y, ch });
            try sym_map.put(.{ x, y }, {});
        }
    }

    // second pass and find all the parts
    for (nums_list.items) |part_num| {
        if (is_part_num(sym_map, part_num)) {
            tot += part_num.num;
        }
    }

    return tot;
}

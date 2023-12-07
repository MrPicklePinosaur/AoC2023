const std = @import("std");
const Tuple = std.meta.Tuple;
const print = std.debug.print;

const Point = Tuple(&.{ usize, usize });
const PartNum = struct {
    num: u32,
    len: usize,
    pos: Point,
};

pub fn solA() !u32 {
    const file = try std.fs.cwd().openFile("src/day3/input.txt", .{});
    defer file.close();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var sym_map = std.AutoHashMap(Point, void).init(allocator);
    // var nums_list = std.ArrayList(PartNum).init(allocator);

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
                while ((x < line_len)) : ({
                    x += 1;
                    i += 1;
                }) {
                    ch = line[x];
                    if (!('0' <= ch and ch <= '9')) break;
                    num = num * 10 + (ch - '0');
                }
                print("got num {d}, len {d}\n", .{ num, i });
                continue;
            }

            // everything else is ymbol
            // print("{d},{d} {c}\n", .{ x, y, ch });
            try sym_map.put(.{ x, y }, {});
        }
    }

    return 0;
}

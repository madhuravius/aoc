//! By convention, root.zig is the root source file when making a library.
const std = @import("std");

const Cell = struct {
    op: ?[]const u8 = null,
    val: u64,
};

pub fn loadFile(allocator: std.mem.Allocator, path: []u8) anyerror![]u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    return try file.readToEndAlloc(allocator, 1 * 8092 * 1024);
}

pub fn parseData(
    allocator: std.mem.Allocator,
    data: []const u8,
) ![][]Cell {
    var result = try std.ArrayList([]Cell).initCapacity(allocator, 0);
    errdefer {
        for (result.items) |row| allocator.free(row);
        result.deinit(allocator);
    }

    var rows = std.mem.splitScalar(u8, data, '\n');
    while (rows.next()) |rowData| {
        var row = try std.ArrayList(Cell).initCapacity(allocator, 0);
        errdefer row.deinit(allocator);

        var cols = std.mem.splitScalar(u8, rowData, ' ');
        while (cols.next()) |col| {
            var isOnlyWhiteSpace: bool = true;
            for (col) |char| {
                if (!std.ascii.isWhitespace(char)) {
                    isOnlyWhiteSpace = false;
                    break;
                }
            }
            if (isOnlyWhiteSpace) {
                continue;
            } else if (std.fmt.parseInt(u64, col, 10) catch null) |value| {
                try row.append(allocator, Cell{ .val = value });
            } else {
                const owned = try allocator.dupe(u8, col);
                try row.append(allocator, Cell{ .val = 0, .op = owned });
            }
        }
        if (row.items.len > 0) {
            try result.append(allocator, try row.toOwnedSlice(allocator));
        }
    }
    return result.toOwnedSlice(allocator);
}

pub fn computeCalculationForColumn(column: u64, data: [][]Cell) u64 {
    const op = data[data.len - 1][column].op.?;
    if (std.mem.eql(u8, op, "+")) {
        var sum: u64 = 0;
        for (0..data.len - 1) |row| {
            sum += data[row][column].val;
        }
        return sum;
    } else if (std.mem.eql(u8, op, "*")) {
        var product: u64 = 1;
        for (0..data.len - 1) |row| {
            product *= data[row][column].val;
        }
        return product;
    }
    return 0;
}

pub fn computeSumForAllColumns(data: [][]Cell) u64 {
    var total: u64 = 0;
    for (0..data[0].len) |col| {
        total += computeCalculationForColumn(@intCast(col), data);
    }
    return total;
}

pub fn freeGrid(allocator: std.mem.Allocator, grid: [][]Cell) void {
    for (grid) |row| {
        for (row) |cell| {
            if (cell.op) |op| {
                allocator.free(op);
            }
        }
        allocator.free(row);
    }
    allocator.free(grid);
}

test "parseData parses numbers and text" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const input =
        \\1 2 foo
        \\3 bar 4
    ;
    const grid = try parseData(allocator, input);
    defer freeGrid(allocator, grid);

    try std.testing.expectEqual(@as(usize, 2), grid.len);
    try std.testing.expectEqual(@as(usize, 3), grid[0].len);

    try std.testing.expectEqual(@as(u64, 1), grid[0][0].val);
    try std.testing.expectEqualStrings("foo", grid[0][2].op.?);
}

test "computeCalculationForColumn for each" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const input =
        \\1 2
        \\3 1
        \\* +
    ;
    const grid = try parseData(allocator, input);
    defer freeGrid(allocator, grid);

    try std.testing.expectEqual(@as(usize, 3), computeCalculationForColumn(0, grid));
    try std.testing.expectEqual(@as(usize, 3), computeCalculationForColumn(1, grid));
}

test "computeCalculationForColumn for example" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const input =
        \\123 328  51 64 
        \\45  64  387 23 
        \\6   98  215 314
        \\*   +   *   +
    ;
    const grid = try parseData(allocator, input);
    defer freeGrid(allocator, grid);

    try std.testing.expectEqual(@as(usize, 4), grid.len);
    try std.testing.expectEqual(@as(usize, 4), grid[0].len);

    try std.testing.expectEqual(@as(usize, 33210), computeCalculationForColumn(0, grid));
    try std.testing.expectEqual(@as(usize, 490), computeCalculationForColumn(1, grid));
    try std.testing.expectEqual(@as(usize, 4243455), computeCalculationForColumn(2, grid));
    try std.testing.expectEqual(@as(usize, 401), computeCalculationForColumn(3, grid));

    try std.testing.expectEqual(@as(usize, 4277556), computeSumForAllColumns(grid));
}

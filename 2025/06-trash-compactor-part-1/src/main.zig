const std = @import("std");
const lib = @import("_06_trash_compactor_part_1");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        std.debug.print("Usage: {s} <filepath>\n", .{args[0]});
        return;
    }
    const filePath = args[1];
    std.debug.print("Loading file from path: {s}\n", .{filePath});

    const fileData = try lib.loadFile(allocator, filePath);
    defer allocator.free(fileData);

    const rawData = try lib.parseData(allocator, fileData);
    std.debug.print("Data fully loaded: {d} rows of data\n", .{rawData.len});
    defer lib.freeGrid(allocator, rawData);

    const total = lib.computeSumForAllColumns(rawData);
    std.debug.print("Total: {d}\n", .{total});
}

import { expect, test } from "bun:test";
import { readFileSync } from "fs";
import { parseSafetyProtocols } from "./parser";

test("safetyProtocols parsed", () => {
	const safetyProtocols = parseSafetyProtocols(
		readFileSync("fixtures/test-input.txt", "utf-8"),
	);
	expect(safetyProtocols.page_ordering_rules[53]).toEqual([29, 13]);
	expect(safetyProtocols.updates[0]).toEqual([75, 47, 61, 53, 29]);
});

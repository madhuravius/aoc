import { expect, test } from "bun:test";
import { readFileSync } from "fs";
import { parseSafetyProtocols } from "./parser";
import {
	filterUpdatesToRules,
	findMedianInUpdates,
	generateMedianSumOfFilteredSafetyProtocols,
	reorderInvalidUpdate,
	validateUpdateOrder,
} from "./order";

test("validateUpdateOrder - can validate order", () => {
	const safetyProtocols = parseSafetyProtocols(
		readFileSync("fixtures/test-input.txt", "utf-8"),
	);
	expect(
		validateUpdateOrder(
			safetyProtocols.updates[0],
			safetyProtocols.page_ordering_rules,
		),
	).toEqual(true);
	expect(
		validateUpdateOrder(
			safetyProtocols.updates[4],
			safetyProtocols.page_ordering_rules,
		),
	).toEqual(false);
});

test("filterUpdatesToRules - can filter validated orders", () => {
	const safetyProtocols = parseSafetyProtocols(
		readFileSync("fixtures/test-input.txt", "utf-8"),
	);

	expect(
		filterUpdatesToRules(
			safetyProtocols.updates,
			safetyProtocols.page_ordering_rules,
		),
	).toEqual([
		[75, 47, 61, 53, 29],
		[97, 61, 53, 29, 13],
		[75, 29, 13],
	]);
});

test("findMedianInUpdates - can find median of array", () => {
	expect(findMedianInUpdates([75, 47, 61, 53, 29])).toEqual(61);
});

test("generateMedianSumOfFilteredSafetyProtocols - can sum filtered and validated rules", () => {
	const safetyProtocols = parseSafetyProtocols(
		readFileSync("fixtures/test-input.txt", "utf-8"),
	);
	expect(generateMedianSumOfFilteredSafetyProtocols(safetyProtocols)).toEqual(
		143,
	);
});

test("reorderInvalidUpdate - can reorder invalid update", () => {
	const safetyProtocols = parseSafetyProtocols(
		readFileSync("fixtures/test-input.txt", "utf-8"),
	);
	expect(
		reorderInvalidUpdate(
			safetyProtocols.updates[3],
			safetyProtocols.page_ordering_rules,
		),
	).toEqual([97, 75, 47, 61, 53]);
	expect(
		reorderInvalidUpdate(
			safetyProtocols.updates[4],
			safetyProtocols.page_ordering_rules,
		),
	).toEqual([61, 29, 13]);
	expect(
		reorderInvalidUpdate(
			safetyProtocols.updates[5],
			safetyProtocols.page_ordering_rules,
		),
	).toEqual([97, 75, 47, 29, 13]);
});

test("generateMedianSumOfFilteredSafetyProtocols - can sum filtered and validated rules with invalid reordering", () => {
	const safetyProtocols = parseSafetyProtocols(
		readFileSync("fixtures/test-input.txt", "utf-8"),
	);
	expect(
		generateMedianSumOfFilteredSafetyProtocols(safetyProtocols, true),
	).toEqual(123);
});

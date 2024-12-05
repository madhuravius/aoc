import type { SafetyProtocols, PageOrderingRules, Updates } from "./types";

export const parseSafetyProtocols = (input: string): SafetyProtocols => {
	const [rawPageOrderingRules, rawUpdates] = input.split("\n\n");

	const page_ordering_rules: PageOrderingRules = {};
	rawPageOrderingRules.split("\n").map((rule) => {
		const [rawKey, rawValue] = rule.split("|");
		const key = parseInt(rawKey, 10);
		const value = parseInt(rawValue, 10);

		page_ordering_rules[key]
			? page_ordering_rules[key].push(value)
			: (page_ordering_rules[key] = [value]);
	});
	const updates: Updates = rawUpdates
		.split("\n")
		.filter((update) => update)
		.map((update) => update.split(","))
		.map((update) => update.map((i) => parseInt(i, 10)));

	return {
		page_ordering_rules,
		updates,
	};
};

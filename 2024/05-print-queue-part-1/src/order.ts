import type { PageOrderingRules, SafetyProtocols, Updates } from "./types";

export const validateUpdateOrder = (
	update: number[],
	pageOrderingRules: PageOrderingRules,
): boolean => {
	for (let i = 0; i < update.length - 1; i++) {
		if (
			!pageOrderingRules[update[i]] ||
			!pageOrderingRules[update[i]].includes(update[i + 1])
		) {
			return false;
		}
	}

	return true;
};

export const filterUpdatesToRules = (
	updates: Updates,
	pageOrderingRules: PageOrderingRules,
): Updates => {
	return updates.filter((update) =>
		validateUpdateOrder(update, pageOrderingRules),
	);
};

export const findMedianInUpdates = (updates: number[]): number =>
	updates[Math.floor(updates.length / 2)];

export const generateMedianSumOfFilteredSafetyProtocols = ({
	updates,
	page_ordering_rules,
}: SafetyProtocols): number =>
	filterUpdatesToRules(updates, page_ordering_rules).reduce((acc, update) => {
		const median = findMedianInUpdates(update);
		return acc + median;
	}, 0);

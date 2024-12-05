import type { PageOrderingRules, SafetyProtocols, Updates } from "./types";

export const reorderInvalidUpdate = (
	update: number[],
	pageOrderingRules: PageOrderingRules,
): number[] => {
	while (!validateUpdateOrder(update, pageOrderingRules)) {
		if (update.length === 1) {
			return update;
		}

		for (let i = 0; i < update.length - 1; i++) {
			if (
				pageOrderingRules[update[i]] &&
				pageOrderingRules[update[i]].includes(update[i + 1])
			) {
				continue;
			} else {
				const temp = update[i];
				update[i] = update[i + 1];
				update[i + 1] = temp;
			}
		}
	}
	return update;
};

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
	filterInvalidOnly: boolean = false,
): Updates => {
	return updates.filter((update) =>
		filterInvalidOnly ? !validateUpdateOrder(update, pageOrderingRules) : validateUpdateOrder(update, pageOrderingRules),
	);
};

export const findMedianInUpdates = (updates: number[]): number =>
	updates[Math.floor(updates.length / 2)];

export const generateMedianSumOfFilteredSafetyProtocols = (
	{ updates, page_ordering_rules }: SafetyProtocols,
	filterInvalid: boolean = false,
): number => {
	const updatesToApply = filterUpdatesToRules(
		updates,
		page_ordering_rules,
		filterInvalid,
	);

	if (filterInvalid) {
		updatesToApply.map((update) =>
			reorderInvalidUpdate(update, page_ordering_rules),
		);
	}

	return updatesToApply.reduce((acc, update) => {
		const median = findMedianInUpdates(update);
		return acc + median;
	}, 0);
};

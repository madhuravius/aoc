export type PageOrderingRules = { [key: number]: number[] };
export type Updates = number[][];

export interface SafetyProtocols {
	page_ordering_rules: PageOrderingRules;
	updates: Updates;
}

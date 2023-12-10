export type Instructions = string[];
export type Node = {
  id: string;
  left: string;
  right: string;
};
export type Network = {
  nodes: { [id: string]: Node };
  head: string;
};

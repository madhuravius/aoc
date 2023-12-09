import { Network } from "./types";

export const parseInput = (input: string) => {
  const [instructions, network] = input.split("\n\n");

  return {
    instructions: instructions.split(""),
    network: parseNetwork(network),
  };
};

export const parseNetwork = (input: string): Network => {
  const network: Network = {
    heads: [],
    nodes: {},
  };
  input
    .trim()
    .split("\n")
    .forEach((line: string) => {
      const [node, linkData] = line.split(" = ");
      const [left, right] = linkData
        .split(", ")
        .map((elem) => elem.replace(/[^0-9A-Z]/g, ""));
      if (node.endsWith("A")) network.heads.push(node);
      network.nodes[node] = {
        id: node,
        left,
        right,
      };
    });
  return network;
};

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
    head: "",
    nodes: {}
  };
  input
    .trim()
    .split("\n")
    .forEach((line: string) => {
      const [node, linkData] = line.split(" = ");
      const [left, right] = linkData
        .split(", ")
        .map((elem) => elem.replace(/[^A-Z]/g, ""));
      if (node === "AAA") network.head = node;
      network.nodes[node] = {
        id: node,
        left,
        right,
      };
    });
  return network;
};

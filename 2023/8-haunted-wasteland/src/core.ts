import { Instructions, Network } from "./types";

export const runThroughInstructions = ({
  instructions,
  network
}: {
  instructions: Instructions,
    network: Network
  }): number => {
  let navigating = true; 
  let step = 0;
  let activeNode = network.nodes[network.head];
  while (navigating) {
    for (const instruction of instructions) {
      if (step % 100000 === 0) {
        console.log(`Processed ${step} steps.`);
      }
      if (activeNode.id === "ZZZ") {
        navigating = false;
        break;
      }

      if (instruction === "R") {
        activeNode = network.nodes[activeNode.right]
      } else {
        activeNode = network.nodes[activeNode.left]
      }
      step += 1;
    }
  }
  return step;
};

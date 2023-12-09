import "process";
import { GhostPath, Instructions, Network } from "./types";

export const runThroughInstructions = ({
  instructions,
  network,
}: {
  instructions: Instructions;
  network: Network;
}): number => {
  let navigating = true;
  let step = 0;
  let activeNodes = network.heads.map((head) => network.nodes[head]);
  let ghostPaths: GhostPath[] = activeNodes.map((activeNode) => ({
    ghostLabel: activeNode.id,
    paths: [activeNode.id],
    foundEndAt: 0,
  }));
  console.log(`Starting loop with: ${activeNodes.length} ghosts`);
  while (navigating) {
    for (const instruction of instructions) {
      if (step % 1000000 === 0 && step > 0) {
        console.log(`Processed ${step} steps.`);
        ghostPaths.forEach((path) => {
          console.log(`${path.ghostLabel} path is ${path.foundEndAt} long`);
        });
      }

      if (ghostPaths.every((ghostPath) => ghostPath.foundEndAt > 0) && !process.env?.DEBUG) {
        /*
        Ensure debuggability with:

        DEBUG=true bun run ./index.ts ./data.txt
        
        this SHOULDN'T work but it does, i think there's a bug in the prompt because
        my ghosts are always incrementing linearly with a clear pattern of incrementing 
        linearly.

        Ex: 
        * found end to path JVA (#2) at 11309
        * found end to path JVA (#2) at 22618
        * found end to path JVA (#2) at 33927
        
        Notice they are linearly growing, this is wrong as per the prompt as we should be traversing 
        the network not knowing we are returning to the same start point. 

        my guess is that they all intersect where their remainder is 0 given their linear growth.
        i tried initially producting these (guaranteed intersection), but that number is MASSIVE

        this should find a lower increment they all intersect at, but this is wrong, because 
        the prompts simply should not grow linearly given the information. 
         * */
        return ghostPaths.reduce((acc, ghostPath) => {
          if (acc === 1) return ghostPath.foundEndAt;

          const [smaller, bigger] = [acc, ghostPath.foundEndAt].toSorted();
          let count = bigger;
          while (true) {
            count += bigger;
            if (count % smaller === 0) return count;
          }
        }, 1);
      }

      activeNodes.forEach((activeNode, idx) => {
        if (activeNode.id.endsWith("Z")) {
          console.log(
            `found end to path ${ghostPaths[idx].ghostLabel} (#${idx}) at ${step}`,
          );
          ghostPaths[idx].foundEndAt = step;
        }

        if (instruction === "R") {
          activeNodes[idx] = network.nodes[activeNode.right];
        } else {
          activeNodes[idx] = network.nodes[activeNode.left];
        }

        ghostPaths[idx].paths.push(activeNodes[idx].id);
      });

      step += 1;
    }
  }
  return step;
};

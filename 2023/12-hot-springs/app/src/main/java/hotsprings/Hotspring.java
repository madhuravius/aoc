package hotsprings;

import java.lang.*;
import java.util.*;
import lombok.*;

public class Hotspring {
    @Getter public final String initialInput;
    @Getter public String hotspringData;
    @Getter public Integer[] contiguousBlockSizes;

    public Hotspring(String input) {
        this.initialInput = input.trim();
        this.parseHotspringFromInput();
    }

    private void parseHotspringFromInput() {
        String[] hotspringInput = this.initialInput.split(" ");
        // first position is spring data, second position is continguous group of damaged springs
        this.hotspringData = hotspringInput[0];
        this.contiguousBlockSizes = this.parseContiguousBlockSizes(hotspringInput[1]);
    }

    public Integer[] parseContiguousBlockSizes(String hotspringLine) {
        return Arrays.stream(hotspringLine.split(","))
            .map((contiguousBlock) -> Integer.parseInt(contiguousBlock))
            .toArray(Integer[]::new);
    }

    public Integer[] translateToContiguousBlockSizes(String permutation) {
        List<Integer> blockSizes = new ArrayList<Integer>();
        Integer counter = 0;
        for (Integer i = 0; i < permutation.length(); i ++) {
            char character = permutation.charAt(i);
            if (character == '.') {
                if (counter > 0) {
                    blockSizes.add(counter);
                }
                counter = 0;
            } else if (character != '.') {
                counter += 1;
            }

            if (counter > 0 && i == permutation.length() - 1) {
                blockSizes.add(counter);
            }
        }
        return blockSizes.toArray(new Integer[blockSizes.size()]);
    }

    public Boolean doesPermutationMatchContiguousBlockSizes(String permutation) {
        return Arrays.equals(translateToContiguousBlockSizes(permutation), this.contiguousBlockSizes);
    }

    public Integer computeAllPermutationsOfBlocks() {
        // for number of ?'s, each one is exponential in terms of possible checks
        // each check must be 0/1, 0/1, 0/1 (ex 2*2*2)
        
        // TODO - break up the data into groups of ?'s, then generate permutations for each separately
        Integer numberOfPermutationsNeeded = Collections.frequency(
                new ArrayList<String>(Arrays.asList(this.hotspringData.split(""))), "?"
                );
       
        // always verify a spam of "." is not 0
        Integer counter = 0; 

        String[] possiblePermutations = generatePermutations(numberOfPermutationsNeeded);

        for (Integer i = 0; i < possiblePermutations.length; i ++ ) {
            // alternate between # and .
            String hotspringDataPermutation = this.hotspringData;
            for (String combinationToReplace : possiblePermutations[i].split("")) {
                hotspringDataPermutation = hotspringDataPermutation.replaceFirst("\\?", combinationToReplace);
            }
            if (doesPermutationMatchContiguousBlockSizes(hotspringDataPermutation)) {
                counter += 1;
            }
        }

        return counter;
    }

    public String[] generatePermutations(int length) {
        List<String> permutations = new ArrayList<>();
        for (int i = 0; i < (1 << length); i++) {
            StringBuilder permutationBuilder = new StringBuilder();
            String binaryString = Integer.toBinaryString(i);

            while (binaryString.length() < length) {
                binaryString = "0" + binaryString;
            }
            permutationBuilder.append(binaryString);
            String permutation = permutationBuilder.toString();

            permutation = permutation.replace("0", ".").replace("1", "#");
            permutations.add(permutation);
        }
        return permutations.toArray(new String[permutations.size()]);
    }
}

package hotsprings;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class HotspringTest {
    @Test void testParseHotSpring() {
        String hotspringInput = "???.### 1,1,3";

        Hotspring hotspring = new Hotspring(hotspringInput);
        assertEquals(hotspring.hotspringData, "???.###");
        assertEquals(hotspring.contiguousBlockSizes.length, 3);
        assertArrayEquals(hotspring.contiguousBlockSizes, new Integer[] {1, 1, 3});
    }

    @Test void testPermutationMatchCheck() {
        String hotspringInput = "???.### 1,1,3";

        Hotspring hotspring = new Hotspring(hotspringInput);
        assertEquals(hotspring.doesPermutationMatchContiguousBlockSizes(
                        "#.#.###"
                    ), true); 
    }

    @Test void testComputeAllPermutationsOfBlocks() {
        assertEquals(new Hotspring("???.### 1,1,3").computeAllPermutationsOfBlocks(), 1); 
        assertEquals(new Hotspring(".??..??...?##. 1,1,3").computeAllPermutationsOfBlocks(), 4); 
        assertEquals(new Hotspring("?#?#?#?#?#?#?#? 1,3,1,6").computeAllPermutationsOfBlocks(), 1); 
        assertEquals(new Hotspring("????.#...#... 4,1,1").computeAllPermutationsOfBlocks(), 1); 
        assertEquals(new Hotspring("????.######..#####. 1,6,5").computeAllPermutationsOfBlocks(), 4); 
        assertEquals(new Hotspring("?###???????? 3,2,1").computeAllPermutationsOfBlocks(), 10); 
    }

    @Test void testGeneratePermutations() {
        assertArrayEquals(new Hotspring("# 1").generatePermutations(2), new String[] {"..", ".#", "#.", "##"});
        assertArrayEquals(new Hotspring("# 1").generatePermutations(3), new String[] {
            "...",
            "..#",
            ".#.",
            ".##",
            "#..",
            "#.#",
            "##.",
            "###",
        });
    }
}

package hotsprings;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class HotspringsTest {
    String hotspringsInput = """
        ???.### 1,1,3
        .??..??...?##. 1,1,3
        ?#?#?#?#?#?#?#? 1,3,1,6
        ????.#...#... 4,1,1
        ????.######..#####. 1,6,5
        ?###???????? 3,2,1
    """;
    @Test void parseHotSprings() {
        Hotsprings hotsprings = new Hotsprings(hotspringsInput);
        assertEquals(hotsprings.hotsprings.length, 6);
        assertEquals(hotsprings.hotsprings[0].contiguousBlockSizes.length, 3);
        assertEquals(hotsprings.hotsprings[2].contiguousBlockSizes.length, 4);
    }
    @Test void checkTotalArrangementsSumofHotSprings() {
        Hotsprings hotsprings = new Hotsprings(hotspringsInput);
        assertEquals(hotsprings.sumAllPossibleHotspringsArrangements(), 21);
    }
}

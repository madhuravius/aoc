package calorieCounting;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class ElvesTest {
    @Test void parseAllCalories() {
        String sampleCaloriesInput = """
            1000
            2000
            3000

            4000

            5000
            6000

            7000
            8000
            9000

            10000
        """;
        Elves elves = new Elves(sampleCaloriesInput);
        assertEquals(elves.elves.length, 5);
        assertEquals(elves.elves[0].caloriesSum(), 6000);
        assertEquals(elves.elves[1].caloriesSum(), 4000);
        assertEquals(elves.elves[2].caloriesSum(), 11000);
        assertEquals(elves.elves[3].caloriesSum(), 24000);
        assertEquals(elves.elves[4].caloriesSum(), 10000);
        assertEquals(elves.maxCalories(), 24000);
    }
}

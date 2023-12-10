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
        /*
         * In case the Elves get hungry and need extra snacks, they need to know which Elf to ask: 
         * they'd like to know how many Calories are being carried by the Elf carrying the most Calories. 
         * In the example above, this is 24000 (carried by the fourth Elf).
        */
        assertEquals(elves.maxCalories(), 24000);
        /**
         * In the example above, the top three Elves are the fourth Elf (with 24000 Calories),
         * then the third Elf (with 11000 Calories), then the fifth Elf (with 10000 Calories). 
         * The sum of the Calories carried by these three elves is 45000.
        */
        assertEquals(elves.maximumNCalories(3), 45000);
    }
}

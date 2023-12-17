package reflector;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class ReflectorDishTest {
    @Test void testParseReflectorDishFromInput() throws Exception {
        String reflectorDishInput = "#.O\n...\n.O.";

        ReflectorDish dish = new ReflectorDish(reflectorDishInput);
	assertEquals(dish.squareRockPositions.size(), 1);
	assertEquals(dish.squareRockPositions.get(new RockPosition(0, 0)), true);
	assertEquals(dish.roundRockPositions.size(), 2);
	assertEquals(dish.roundRockPositions.get(new RockPosition(2, 0)), true);
	assertEquals(dish.roundRockPositions.get(new RockPosition(1, 2)), true);
	assertEquals(dish.initialData.length, 3);
    }
    @Test void testParseReflectorAndPushNorth() throws Exception {
        String reflectorDishInput = "#.O\n...\n.O.";

        ReflectorDish dish = new ReflectorDish(reflectorDishInput);
	assertArrayEquals(dish.pushAllRoundRocksNorth(), new String[][] {
	    {"#", "O", "O"},
	    {".", ".", "."},
	    {".", ".", "."},
	});
    }
    @Test void testParseReflectorAndScorer() throws Exception {
        String reflectorDishInput = "#.O\n...\n.O.";

        ReflectorDish dish = new ReflectorDish(reflectorDishInput);
	Scorer scorer = new Scorer(dish.pushAllRoundRocksNorth());
	assertEquals(scorer.computeLoad(), 6);
    }
    @Test void testParseReflectorAndScorerTestCase() throws Exception {
        String reflectorDishInput = "O....#....\nO.OO#....#\n.....##...\nOO.#O....O\n.O.....O#.\nO.#..O.#.#\n..O..#O..O\n.......O..\n#....###..\n#OO..#....";

        ReflectorDish dish = new ReflectorDish(reflectorDishInput);
	Scorer scorer = new Scorer(dish.pushAllRoundRocksNorth());
	assertEquals(scorer.computeLoad(), 136);
    }
}

package hotsprings;

import java.lang.*;
import java.util.*;
import lombok.*;

public class Hotsprings {
    @Getter public final String initialInput;
    @Getter public Hotspring[] hotsprings;

    public Hotsprings(String input) {
        this.initialInput = input.trim();
        this.parseHotspringsFromInput();
    }

    private void parseHotspringsFromInput() {
        String[] hotspringsInputs = this.initialInput.split("\n");
        this.hotsprings = Arrays.stream(hotspringsInputs).map((hotspringInput) -> new Hotspring(hotspringInput)).toArray(Hotspring[]::new);
    }

    public Integer sumAllPossibleHotspringsArrangements() {
        return Arrays
            .stream(this.hotsprings).map((hotspring) -> hotspring.computeAllPermutationsOfBlocks())
            .mapToInt(d-> d)
            .sum();
    }
}

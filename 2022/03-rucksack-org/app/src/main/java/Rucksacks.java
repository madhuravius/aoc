package rucksackOrg;

import java.util.*;
import lombok.*;

public class Rucksacks {
    private final String initialInput;

    @Getter public Rucksack[] rucksacks;
    
    public Rucksacks(String input) {
      this.initialInput = input;
      this.generateRucksacksFromInput();
    }
    
    private void generateRucksacksFromInput(){
        String[] rucksackInputs = this.initialInput.split("\n");
        this.rucksacks = Arrays.stream(rucksackInputs).map((rucksackInput) -> new Rucksack(rucksackInput)).toArray(Rucksack[]::new);
    }

    public Integer sumPriorityScoresOfRucksacks() {
        return Arrays
            .stream(this.rucksacks).map((rucksack) -> rucksack.priorityScore())
            .mapToInt(d-> d)
            .sum();
    }
}

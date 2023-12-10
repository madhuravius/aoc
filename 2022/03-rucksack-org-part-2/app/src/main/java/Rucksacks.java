package rucksackOrg;

import java.util.*;
import lombok.*;

public class Rucksacks {
    private final String initialInput;

    @Getter public Rucksack[] rucksacks;
    @Getter public RucksackGroup[] rucksackGroups;
    
    public Rucksacks(String input) {
      this.initialInput = input;
      this.generateRucksacksFromInput();
      this.generateRucksackGroups();
    }
    
    private void generateRucksacksFromInput(){
        String[] rucksackInputs = this.initialInput.split("\n");
        this.rucksacks = Arrays.stream(rucksackInputs).map((rucksackInput) -> new Rucksack(rucksackInput)).toArray(Rucksack[]::new);
    }

    private void generateRucksackGroups() {
        RucksackGroup[] rucksackGroups = new RucksackGroup [ this.rucksacks.length / 3];
        for (var i = 0; i < this.rucksacks.length ; i += 3) {
            // rucksackgroups are in groups of 3 apparently
            Rucksack[] rucksacks = {this.rucksacks[i], this.rucksacks[i+1], this.rucksacks[i+2]};
            rucksackGroups[i/3] = new RucksackGroup(rucksacks);
        }
        this.rucksackGroups = rucksackGroups;
    }

    public Integer sumPriorityScoresOfRucksacks() {
        return Arrays
            .stream(this.rucksacks).map((rucksack) -> rucksack.priorityScore())
            .mapToInt(d-> d)
            .sum();
    }
    
    public Integer sumPriorityScoresOfRucksackGroups() {
        return Arrays
            .stream(this.rucksackGroups).map((rucksackGroup) -> rucksackGroup.priorityScore())
            .mapToInt(d-> d)
            .sum();
    }
}

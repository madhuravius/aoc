package calorieCounting;

import java.util.*;
import lombok.*;

public class Elves {
    private final String initialInput;

    @Getter public Elf[] elves;
    
    public Elves(String input) {
      this.initialInput = input;
      this.generateElvesFromInput();
    }
    
    private void generateElvesFromInput(){
        String[] elfInputs = this.initialInput.split("\n\n");
        this.elves = Arrays.stream(elfInputs).map((elfInput) -> new Elf(elfInput)).toArray(Elf[]::new);
    }

    public Integer maxCalories() {
        Integer maximumCalories = 0;
        for(Elf elf : elves) {
            Integer elfCalories = elf.caloriesSum();
            if(elfCalories > maximumCalories) {
               maximumCalories = elfCalories;
            }
        }
        return maximumCalories;
    }

    public Integer maximumNCalories(Integer n) {
        Integer[] maximumSetOfCalories = new Integer [ elves.length ]; 
        Integer idx = 0;
        for (Elf elf : elves) {
            maximumSetOfCalories[idx] = elf.caloriesSum();
            idx ++;
        }
        Arrays.sort(maximumSetOfCalories, Collections.reverseOrder());
        Integer maximumCaloriesSum = 0;
        idx = 0;
        while (idx < n) {
            maximumCaloriesSum += maximumSetOfCalories[idx];
            idx ++;
        }
        return maximumCaloriesSum;
    }
}

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
}

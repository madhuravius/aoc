package calorieCounting;

import java.lang.*;
import java.util.*;
import lombok.*;

public class Elf {
    private final String initialInput;

    @Getter public Integer[] calories;

    public Elf(String input) {
        this.initialInput = input;
        this.generateCaloriesFromInput();
    }

    private void generateCaloriesFromInput() {
        String[] caloriesInputs = this.initialInput.split("\n");
        this.calories = Arrays.stream(caloriesInputs).map((calorieInput) -> Integer.parseInt(calorieInput.replaceAll("\\s",""))).toArray(Integer[]::new);
    }

    public Integer caloriesSum() {
        return Arrays.stream(this.calories).mapToInt(Integer::intValue).sum();
    }
}

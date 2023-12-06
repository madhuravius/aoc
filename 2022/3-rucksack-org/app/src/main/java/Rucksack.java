package rucksackOrg;

import java.lang.*;
import java.util.*;
import lombok.*;

public class Rucksack {
    private final String initialInput;

    @Getter public String[] compartments;

    final static String alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

    public Rucksack(String input) {
        this.initialInput = input.replaceAll("\\s+","");
        this.generateCompartmentsFromInput();
    }

    private void generateCompartmentsFromInput() {
        final Integer half = this.initialInput.length() / 2;
        this.compartments = new String[] { this.initialInput.substring(0, half), this.initialInput.substring(half) };
    }

    public String commonCompartmentItems() {
        String commonItems = "";
        for (int i = 0; i < compartments[0].length(); i++) {
            String characterChecked = String.valueOf(compartments[0].charAt(i));
            if (compartments[1].contains(characterChecked) && !commonItems.contains(characterChecked)) {
                commonItems += characterChecked;
            }
        }
        return commonItems;
    }

    public Integer priorityScore() {
        Integer score = 0;
        String commonCompartmentItems = this.commonCompartmentItems();
        for (int i = 0; i < commonCompartmentItems.length(); i++) {
            String characterChecked = String.valueOf(commonCompartmentItems.charAt(i));
            score += (this.alphabet.indexOf(characterChecked) + 1);
        }
        return score;
    }
}

package rucksackOrg;

import java.util.*;
import lombok.*;

public class RucksackGroup {
    @Getter public Rucksack[] rucksacks;

    public RucksackGroup(Rucksack[] rucksacks) {
        this.rucksacks = rucksacks;
    }

    public String commonRucksackItems() {
        String[] commonStrings = new String [ this.rucksacks.length - 1 ];
        // always start at 1, as that rucksack is the default comparator
        for (int r = 1; r < this.rucksacks.length; r++) {
            String commonBetweenImmediateComparisons = "";
            for (int i = 0; i < this.rucksacks[0].initialInput.length(); i++) {
                String characterChecked = String.valueOf(this.rucksacks[0].initialInput.charAt(i));
                if (this.rucksacks[r].initialInput.contains(characterChecked) && !commonBetweenImmediateComparisons.contains(characterChecked)) {
                    commonBetweenImmediateComparisons += characterChecked;
                }
            }
            commonStrings[r - 1] = commonBetweenImmediateComparisons;
        }

        String commonItems = "";
        for (int i = 0; i < commonStrings[0].length(); i++) {
            String characterChecked = String.valueOf(commonStrings[0].charAt(i));
            if (commonStrings[1].contains(characterChecked) && !commonItems.contains(characterChecked)) {
                commonItems += characterChecked;
            }
        }
        return commonItems;
    } 
    
    public Integer priorityScore() {
        Integer score = 0;
        String commonRucksackItems = this.commonRucksackItems();
        for (int i = 0; i < commonRucksackItems.length(); i++) {
            String characterChecked = String.valueOf(commonRucksackItems.charAt(i));
            score += (Constants.alphabet.indexOf(characterChecked) + 1);
        }
        return score;
    }
}

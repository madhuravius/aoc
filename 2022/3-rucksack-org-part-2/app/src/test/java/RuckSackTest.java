package rucksackOrg;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class RucksackTest {
    @Test void parseRucksacks() {
        String sampleRucksacksInput = """
            vJrwpWtwJgWrhcsFMMfFFhFp
            jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
            PmmdzqPrVvPwwTWBwg
            wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
            ttgJtRGJQctTZtZT
            CrZsJsPPZsGzwwsLwLmpwMDw
        """;
        Rucksacks rucksacks = new Rucksacks(sampleRucksacksInput);
        assertEquals(rucksacks.rucksacks.length, 6);
        assertEquals(rucksacks.rucksackGroups.length, 2);
        assertEquals(rucksacks.rucksacks[0].compartments.length, 2);
        assertEquals(rucksacks.rucksacks[0].compartments[0], "vJrwpWtwJgWr");
        assertEquals(rucksacks.rucksacks[0].compartments[1], "hcsFMMfFFhFp");
    }

    @Test void testRucksackCommonItems() {
        String sampleInput = "vJrwpWtwJgWrhcsFMMfFFhFp";
        Rucksack rucksack = new Rucksack(sampleInput);
        assertEquals(rucksack.commonCompartmentItems(), "p");
    }
    
    @Test void testRucksackScore() {
        String sampleInput = "vJrwpWtwJgWrhcsFMMfFFhFp";
        Rucksack rucksack = new Rucksack(sampleInput);
        assertEquals(rucksack.priorityScore(), 16);
    }

    @Test void testRucksacksSum() {
        String sampleRucksacksInput = """
            vJrwpWtwJgWrhcsFMMfFFhFp
            jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
            PmmdzqPrVvPwwTWBwg
            wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
            ttgJtRGJQctTZtZT
            CrZsJsPPZsGzwwsLwLmpwMDw
        """;
        Rucksacks rucksacks = new Rucksacks(sampleRucksacksInput);
        assertEquals(rucksacks.sumPriorityScoresOfRucksacks(), 157);
    }

    @Test void testRucksackGroupCommonRucksackItems() {
        String sampleRucksacksInput = """
            vJrwpWtwJgWrhcsFMMfFFhFp
            jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
            PmmdzqPrVvPwwTWBwg
        """;
        Rucksacks rucksacks = new Rucksacks(sampleRucksacksInput);
        RucksackGroup rucksackGroup = new RucksackGroup(rucksacks.rucksacks);
        assertEquals(rucksackGroup.commonRucksackItems(), "r");
    }
    
    @Test void testRucksackGroupPriorityScore() {
        String sampleRucksacksInput = """
            vJrwpWtwJgWrhcsFMMfFFhFp
            jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
            PmmdzqPrVvPwwTWBwg
        """;
        Rucksacks rucksacks = new Rucksacks(sampleRucksacksInput);
        RucksackGroup rucksackGroup = new RucksackGroup(rucksacks.rucksacks);
        assertEquals(rucksackGroup.priorityScore(), 18);
    }
    
    @Test void testRucksackGroupsSum() {
        String sampleRucksacksInput = """
            vJrwpWtwJgWrhcsFMMfFFhFp
            jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
            PmmdzqPrVvPwwTWBwg
            wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
            ttgJtRGJQctTZtZT
            CrZsJsPPZsGzwwsLwLmpwMDw
        """;
        Rucksacks rucksacks = new Rucksacks(sampleRucksacksInput);
        assertEquals(rucksacks.sumPriorityScoresOfRucksackGroups(), 70);
    }
}

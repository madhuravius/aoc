package rucksackOrg;

import java.io.*;
import java.nio.file.*;

// https://adventofcode.com/2022/day/3

public class App {
    public static void main(String[] args) throws IOException {
        if (args.length == 0) {
            throw new RuntimeException("Not enough args to act on - easiest to run with \"gradle run --args=\"$PWD/data.txt\"\"");
        }
        String content = new String(Files.readAllBytes(Paths.get(args[0])));
        Rucksacks rucksacks = new Rucksacks(content);
        System.out.println("Priority score sum in list found as " + rucksacks.sumPriorityScoresOfRucksacks()); 
    }
}

package calorieCounting;

import java.io.*;
import java.nio.file.*;

// https://adventofcode.com/2022/day/1#part2

public class App {
    public static void main(String[] args) throws IOException {
        if (args.length == 0) {
            throw new RuntimeException("Not enough args to act on - easiest to run with \"gradle run --args=\"$PWD/data.txt\"\"");
        }
        
        String content = new String(Files.readAllBytes(Paths.get(args[0])));
        Elves elves = new Elves(content);
        System.out.println("Maximum calories in list found as " + elves.maxCalories()); 
        System.out.println("Maximum calories for 3 elves: " + elves.maximumNCalories(3)); 
    }
}

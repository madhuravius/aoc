package hotsprings;

import java.io.*;
import java.nio.file.*;

// https://adventofcode.com/2023/day/12

public class App {
    public static void main(String[] args) throws IOException {
        if (args.length == 0) {
            throw new RuntimeException("Not enough args to act on - easiest to run with \"gradle run --args=\"$PWD/data.txt\"\"");
        }
        String content = new String(Files.readAllBytes(Paths.get(args[0])));
        Hotsprings hotsprings = new Hotsprings(content);
        System.out.println("Sum of hotsprings arrangement possibilities: " + hotsprings.sumAllPossibleHotspringsArrangements()); 
    }
}

package reflector;

import java.io.*;
import java.nio.file.*;

// https://adventofcode.com/2023/day/14

public class App {
    public static void main(String[] args) throws Exception, IOException {
        if (args.length == 0) {
            throw new RuntimeException("Not enough args to act on - easiest to run with \"gradle run --args=\"$PWD/data.txt\"\"");
        }
        String content = new String(Files.readAllBytes(Paths.get(args[0])));
        ReflectorDish reflector = new ReflectorDish(content);
        Scorer scorer = new Scorer(reflector.pushAllRoundRocksNorth());
        System.out.println("Sum of loadbearing rocks: " + scorer.computeLoad()); 
    }
}

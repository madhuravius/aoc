package reflector;

import java.util.*;
import lombok.*;

public class ReflectorDish {
    @Getter public final String initialInput;
    @Getter public String[][] initialData;
    @Getter public Map<RockPosition, Boolean> roundRockPositions;
    @Getter public Map<RockPosition, Boolean> squareRockPositions;

    public ReflectorDish(String input) throws Exception {
        this.initialInput = input.trim();
        this.roundRockPositions = new HashMap<RockPosition, Boolean>();
        this.squareRockPositions = new HashMap<RockPosition, Boolean>();
        this.parseReflectorDishFromInput();
    }

    public void tiltDishInDirection(String direction) throws Exception {
        switch(direction) {
            case "north":
                System.out.println("Pushing elements north");
                this.pushAllRoundRocksNorth();
            default: 
                throw new Exception("Direction unsupported");
        }
    }

    public String[][] pushAllRoundRocksNorth() {
        Integer yCounter = 0;
        for (String[] line : this.initialData) {
            for (int xCounter = 0; xCounter < line.length; xCounter ++) {
                RockPosition possiblePosition = new RockPosition(xCounter, yCounter);
                if (this.roundRockPositions.get(possiblePosition) != null) {
                    this.pushRockAsNorthAsPossible(possiblePosition);
                }
            }
            yCounter += 1;
        }
        
        if (System.getenv("DEBUG") != null && System.getenv("DEBUG").equals("true")) {
            System.out.println("Transformed Input");
        }
        ArrayList<ArrayList<String>> data = new ArrayList<ArrayList<String>>();
        for (int y = 0; y < this.initialData.length; y ++) {
            ArrayList<String> line = new ArrayList<String>();
            for (int x = 0; x < this.initialData[y].length; x ++) {
                RockPosition possiblePosition = new RockPosition(x, y);
                if (this.roundRockPositions.get(possiblePosition) != null) {
                    line.add("O");
                }
                else if (this.squareRockPositions.get(possiblePosition) != null) {
                    line.add("#");
                }
                else {
                    line.add(".");
                }
            }
            if (System.getenv("DEBUG") != null && System.getenv("DEBUG").equals("true")) {
                System.out.println(line);
            }
            data.add(line);
        }
        return data.stream().map(row -> row.toArray(new String[row.size()])).toArray(String[][]::new);
    }

    public void pushRockAsNorthAsPossible(RockPosition rockPosition) {
        // try to go as far north as possible by deducting one and checking maps. if collision detected, stop there
        // and update self
        Integer currentY = rockPosition.y;
        while (currentY > 0) {
            RockPosition collisionCheck = new RockPosition(rockPosition.x, currentY - 1);
            if (this.roundRockPositions.get(collisionCheck) != null || this.squareRockPositions.get(collisionCheck) != null) {
                break;
            }
            currentY -= 1;
        }
        this.roundRockPositions.remove(rockPosition);
        this.roundRockPositions.put(new RockPosition(rockPosition.x, currentY), true);
    }

    private void parseReflectorDishFromInput() throws Exception {
        if (System.getenv("DEBUG") != null && System.getenv("DEBUG").equals("true")) {
            System.out.println("Initial Input");
        }
        String[] reflectorInputs = this.initialInput.split("\n");
        ArrayList<ArrayList<String>> data = new ArrayList<ArrayList<String>>();
        Integer yCounter = 0;
        for (String line : reflectorInputs) {

            Integer xCounter = 0;
            String[] splitLine = line.split("");
            ArrayList<String> charactersToSave = new ArrayList<String>();
            for (String character : splitLine) {
                switch (character) {
                    case "O" -> this.roundRockPositions.put(new RockPosition(xCounter, yCounter), true);
                    case "#" -> this.squareRockPositions.put(new RockPosition(xCounter, yCounter), true);
                    default -> {}
                }
                charactersToSave.add(character);
                xCounter += 1;
            }
            data.add(charactersToSave);
            if (System.getenv("DEBUG") != null && System.getenv("DEBUG").equals("true")) {
                System.out.println(charactersToSave);
            }
            yCounter += 1;
        }
        this.initialData = data.stream().map(row -> row.toArray(new String[row.size()])).toArray(String[][]::new);
    }
}

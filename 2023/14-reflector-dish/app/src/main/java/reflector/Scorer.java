package reflector;

import lombok.*;

public class Scorer {
    @Getter public String[][] data;

    public Scorer(String[][] data) {
        this.data = data;
    }

    public Integer computeLoad() {
        Integer score = 0;
        for (Integer row = data.length - 1; row >= 0; row --) {
            for (Integer character = 0; character < this.data[row].length; character ++) {
                if (this.data[row][character] == "O") {
                    score += (data.length - row);
                }
            }
        }
        return score;
    }
}

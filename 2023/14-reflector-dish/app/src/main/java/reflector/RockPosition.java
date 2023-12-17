package reflector;

import java.util.*;

class RockPosition {
    public int x;
    public int y;

    public RockPosition(int x,int y) {
        this.x = x;
        this.y = y;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;

        RockPosition rockPosition = (RockPosition) o;
        return x == rockPosition.x && y == rockPosition.y;
    }

    @Override
    public int hashCode() {
        return Objects.hash(x, ".", y);
    }
}

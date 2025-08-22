package e2;

public class Slopes {

    public static int downTheSlope(char [][] slopeMap , int right , int down) {

        int i = 0, j = 0, count = 0, aux;
        int x, y, b, c;

        for(aux = 1; aux<slopeMap.length; aux++){
            if(slopeMap[aux].length != slopeMap[aux-1].length){
                throw new IllegalArgumentException();
            }
        }
        for(b = 0; b < slopeMap.length; b++){
            for(c = 0; c < slopeMap[0].length; c++){
                if(slopeMap[b][c] != '.' && slopeMap[b][c] != '#'){
                    throw new IllegalArgumentException();
                }
            }
        }
        if(right >= slopeMap[0].length || right < 1){
            throw new IllegalArgumentException();
        }
        if(down >= slopeMap.length || down < 1){
            throw new IllegalArgumentException();
        }
        else{
            while(i < slopeMap.length){
                for(x = 0; x < right; x++){
                    j++;
                    if(j == slopeMap.length){
                        j -= slopeMap.length;
                    }
                    if(slopeMap[i][j] == 35){
                        count++;
                    }
                }
                for(y = 0; y < down; y++){
                    i++;
                    if(i == slopeMap.length){
                        break;
                    }
                    else if(slopeMap[i][j] == 35){
                        count++;
                    }
                }
            }
        }
        return count;
    }

    public static int jumpTheSlope(char [][] slopeMap , int right , int down) {

        int i = 0, j = 0, count  = 0;
        int x, y, au;

        if (slopeMap.length != slopeMap[0].length) {
            throw new IllegalArgumentException();
        }
        for (au = 1; au < slopeMap.length; au++) {
            if (slopeMap[au].length != slopeMap[au - 1].length) {
                throw new IllegalArgumentException();
            }
        }
        for (char[] aux : slopeMap) {
            for (char auc : aux) {
                if (auc != '.' && auc != '#') {
                    throw new IllegalArgumentException();
                }
            }
        }
        if (right >= slopeMap[0].length || right < 1) {
            throw new IllegalArgumentException();
        }
        if (down >= slopeMap.length || down < 1) {
            throw new IllegalArgumentException();
        }
        else {
            while (i < slopeMap.length) {
                for (x = 0; x < right; x++) {
                    j++;
                    if (j == slopeMap.length) {
                        j -= slopeMap.length;
                    }
                }
                for (y = 0; y < down; y++) {
                    i++;
                    if (i == slopeMap.length) {
                        break;
                    } else if (y == down - 1) {
                        if (slopeMap[i][j] == 35) {
                            count++;
                        }
                    }
                }
            }
            return count;
        }
    }
}
package e1;

public class StringCount {

    public static int countWords(String text) {
        int count = 1, pos;

        if (text == null) {
            count = 0;
        }
        else {
            text = text.trim();
            text = text.replaceAll("( )+", " ");
            pos = text.indexOf(" ");
            while (pos != -1) {
                count++;
                pos = text.indexOf(" ", pos + 1);
            }
        }
        return count;
    }

    public static int countChar(String text, char c) {

        int pos, count = 0;

        if(text != null){
            pos = text.indexOf(c);
            while(pos != -1){
                count++;
                pos = text.indexOf(c,pos+1);
            }
        }
        else{
            return count;
        }
        return count;
    }

    public static int countCharIgnoringCase(String text , char c) {

        int count = 0, pos;

        if(text!=null){
            c = Character.toLowerCase(c);
            text = text.toLowerCase();
            pos = text.indexOf(c);
            while(pos != -1){
                c = text.charAt(pos);

                if(text.charAt(pos) >= 97 && text.charAt(pos) <= 122){
                    count++;
                    pos = text.indexOf(c,pos+1);
                }
                else if(text.charAt(pos) >= 241 && text.charAt(pos) <= 250){
                    count++;
                    pos = text.indexOf(c,pos+1);
                }
            }
        }
        else{
            return count;
        }
        return count;
    }

    public static boolean isPasswordSafe(String password) {
        boolean result = false, upper= false, lower= false, digit= false, special = false;
        char aux;
        int i;

        for(i = 0; i < password.length(); i++){
            aux = password.charAt(i);

            if(Character.isUpperCase(aux)){
                upper = true;
            }
            else if(Character.isLowerCase(aux)){
                lower = true;
            }
            else if(Character.isDigit(aux)){
                digit = true;
            }
            else if(password.charAt(i) == 63 || password.charAt(i) == 64 || password.charAt(i) == 35 || password.charAt(i) == 36 || password.charAt(i) == 46 || password.charAt(i) == 44){
                special = true;
            }
        }
        if(password.length() > 8){
            if(upper && lower && digit && special){
                result = true;
            }
        }
        return result;
    }
}
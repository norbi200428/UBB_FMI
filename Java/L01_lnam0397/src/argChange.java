public class argChange {
    public static void main(String[] args) {
        for(int i = 0; i < args.length; i++) {
            String arg = args[i];
            for(int j = 0; j < arg.length(); j++) {
                char ch = arg.charAt(j);
                if(Character.isLowerCase(ch)) {
                    System.out.print(Character.toUpperCase(ch));
                } else if (Character.isUpperCase(ch)) {
                    System.out.print(Character.toLowerCase(ch));
                } else {
                    System.out.print(ch);
                }
            }
            System.out.println();
        }
    }
}

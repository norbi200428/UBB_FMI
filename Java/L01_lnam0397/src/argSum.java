public class argSum {
    public static void main(String[] args) {
        int evenSum = 0;
        int oddSum = 0;

        for (int i = 0; i < args.length; i++) {
            try {
                int nr = Integer.parseInt(args[i]);
                if (nr % 2 == 0) {
                    evenSum += nr;
                } else {
                    oddSum += nr;
                }
            } catch (NumberFormatException e) {
                System.out.println(e.getMessage());
            }
        }
        System.out.println("Paros osszeg: " + evenSum);
        System.out.println("Paratlan osszeg: " + oddSum);
    }
}

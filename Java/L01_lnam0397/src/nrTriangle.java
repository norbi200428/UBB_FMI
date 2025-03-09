public class nrTriangle {
    public static void main(String[] args) {
        int n = 10;
        if (args.length > 0) {
            try {
                n = Integer.parseInt(args[0]);
                if (n <= 0) {
                    System.out.println("n must be greater than 0");
                    n = 10;
                }
            } catch (NumberFormatException e) {
                System.out.println("Error! n must be a number.");
            }
        }

        int nr = 1;
        int[][] tomb = new int[n][];
        for (int i = 1; i <= n; i++) {
            tomb[i - 1] = new int[i];
            for (int j = 0; j < i; j++) {
                tomb[i - 1][j] = nr++;
                System.out.print(tomb[i - 1][j] + " ");
            }
            System.out.println();
        }
    }
}

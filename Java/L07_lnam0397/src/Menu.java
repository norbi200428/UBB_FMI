public class Menu {
    private Soup soup;
    private MainDish mainDish;

    public void createMenu(Chef chef){
        this.soup = chef.prepareSoup();
        this.mainDish = chef.prepareMainDish();
        this.soup.associateMainDish(this.mainDish);
    }

    public static void main(String[] args) {
        Menu kinaiMenu = new Menu();
        kinaiMenu.createMenu(new ChineseChef());

        Menu indiaiMenu = new Menu();
        indiaiMenu.createMenu(new IndianChef());
    }
}
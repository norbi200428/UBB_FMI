public class KlangBakKutTehSoup implements Soup{

    @Override
    public void associateMainDish(MainDish mainDish) {
        System.out.println("A " + this + " leveshez a " + mainDish + " leves tartozik.");
    }

    @Override
    public String toString(){
        return this.getClass().getSimpleName();
    }
}

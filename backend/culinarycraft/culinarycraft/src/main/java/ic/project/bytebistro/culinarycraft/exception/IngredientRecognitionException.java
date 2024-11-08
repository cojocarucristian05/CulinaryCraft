package ic.project.bytebistro.culinarycraft.exception;

public class IngredientRecognitionException extends RuntimeException {

    public IngredientRecognitionException() {
        this("Ingredient recognition failed!");
    }

    public IngredientRecognitionException(String message) {
        super(message);
    }

}

package ic.project.bytebistro.culinarycraft.exception;

public class IngredientNotFoundException extends RuntimeException {
    public IngredientNotFoundException() {
        this("Ingredient not found.");
    }

    public IngredientNotFoundException(String message) {
        super(message);
    }
}

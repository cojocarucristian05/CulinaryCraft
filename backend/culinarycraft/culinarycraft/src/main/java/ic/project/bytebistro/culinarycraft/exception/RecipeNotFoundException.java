package ic.project.bytebistro.culinarycraft.exception;

public class RecipeNotFoundException extends RuntimeException {
    public RecipeNotFoundException() {
        this("Recipe not found!");
    }

    public RecipeNotFoundException(String message) {
        super(message);
    }
}

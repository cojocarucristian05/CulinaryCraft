package ic.project.bytebistro.culinarycraft.exception;

public class RecipeAlreadyLikedException extends RuntimeException {
    public RecipeAlreadyLikedException() {
        this("You already liked this recipe");
    }

    public RecipeAlreadyLikedException(String message) {
        super(message);
    }
}

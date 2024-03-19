package ic.project.bytebistro.culinarycraft.exception;

public class UserNotFoundException extends RuntimeException {
    public UserNotFoundException() {
        this("User not found!");
    }

    public UserNotFoundException(String message) {
        super(message);
    }
}

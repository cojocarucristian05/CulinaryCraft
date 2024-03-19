package ic.project.bytebistro.culinarycraft.exception;

public class UserAlreadyExistException extends RuntimeException {
    public UserAlreadyExistException() {
        this("User already exist!");
    }

    public UserAlreadyExistException(String message) {
        super(message);
    }
}

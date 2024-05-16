package ic.project.bytebistro.culinarycraft.exception;

public class UserInactiveException extends RuntimeException {
    public UserInactiveException() {
        this("This account is inactive!");
    }

    public UserInactiveException(String message) {
        super(message);
    }
}

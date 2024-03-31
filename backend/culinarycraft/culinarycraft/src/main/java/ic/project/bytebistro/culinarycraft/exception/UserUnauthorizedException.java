package ic.project.bytebistro.culinarycraft.exception;

public class UserUnauthorizedException extends RuntimeException {
    public UserUnauthorizedException() {
        this("Invalid credentials!");
    }

    public UserUnauthorizedException(String message) {
        super(message);
    }
}

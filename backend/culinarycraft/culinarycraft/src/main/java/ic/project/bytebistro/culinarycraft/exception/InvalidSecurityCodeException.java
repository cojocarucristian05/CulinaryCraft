package ic.project.bytebistro.culinarycraft.exception;

public class InvalidSecurityCodeException extends RuntimeException {
    public InvalidSecurityCodeException() {
        this("Invalid security code!");
    }

    public InvalidSecurityCodeException(String message) {
        super(message);
    }
}

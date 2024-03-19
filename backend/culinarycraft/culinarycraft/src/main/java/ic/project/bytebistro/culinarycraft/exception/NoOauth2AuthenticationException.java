package ic.project.bytebistro.culinarycraft.exception;

public class NoOauth2AuthenticationException extends RuntimeException {
    public NoOauth2AuthenticationException() {
        this("You are not using oauth2!");
    }

    public NoOauth2AuthenticationException(String message) {
        super(message);
    }
}

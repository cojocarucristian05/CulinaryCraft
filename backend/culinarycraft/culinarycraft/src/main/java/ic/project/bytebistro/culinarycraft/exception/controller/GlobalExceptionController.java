package ic.project.bytebistro.culinarycraft.exception.controller;

import ic.project.bytebistro.culinarycraft.exception.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.security.NoSuchAlgorithmException;

@ControllerAdvice
public class GlobalExceptionController {

    @ExceptionHandler(value = UserNotFoundException.class)
    public ResponseEntity<String> handleUserNotFoundException(UserNotFoundException userNotFoundException) {
        return new ResponseEntity<>(userNotFoundException.getMessage(), HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(value = UserAlreadyExistException.class)
    public ResponseEntity<String> handleUserAlreadyExistException(UserAlreadyExistException userAlreadyExistException) {
        return new ResponseEntity<>(userAlreadyExistException.getMessage(), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(value = NoOauth2AuthenticationException.class)
    public ResponseEntity<String> handelNoOauth2AuthenticationException(NoOauth2AuthenticationException noOauth2AuthenticationException) {
        return new ResponseEntity<>(noOauth2AuthenticationException.getMessage(), HttpStatus.FORBIDDEN);
    }

    @ExceptionHandler(value = NoSuchAlgorithmException.class)
    public ResponseEntity<String> handelNoSuchAlgorithmException(NoSuchAlgorithmException noSuchAlgorithmException) {
        return new ResponseEntity<>(noSuchAlgorithmException.getMessage(), HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(value = UserUnauthorizedException.class)
    public ResponseEntity<String> handelNoSuchAlgorithmException(UserUnauthorizedException userUnauthorizedException) {
        return new ResponseEntity<>(userUnauthorizedException.getMessage(), HttpStatus.UNAUTHORIZED);
    }

    @ExceptionHandler(value = InvalidSecurityCodeException.class)
    public ResponseEntity<String> handelInvalidSecurityCodeException(InvalidSecurityCodeException invalidSecurityCodeException) {
        return new ResponseEntity<>(invalidSecurityCodeException.getMessage(), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(value = ImageNotFoundException.class)
    public ResponseEntity<String> handelImageNotFoundException(ImageNotFoundException imageNotFoundException) {
        return new ResponseEntity<>(imageNotFoundException.getMessage(), HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(value = UserInactiveException.class)
    public ResponseEntity<String> handleUserInactiveException(UserInactiveException userInactiveException) {
        return new ResponseEntity<>(userInactiveException.getMessage(), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(value = RecipeNotFoundException.class)
    public ResponseEntity<String> handleRecipeNotFoundException(RecipeNotFoundException recipeNotFoundException) {
        return new ResponseEntity<>(recipeNotFoundException.getMessage(), HttpStatus.BAD_REQUEST);
    }

}

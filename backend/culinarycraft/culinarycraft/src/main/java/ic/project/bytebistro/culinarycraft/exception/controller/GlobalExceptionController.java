package ic.project.bytebistro.culinarycraft.exception.controller;

import ic.project.bytebistro.culinarycraft.exception.NoOauth2AuthenticationException;
import ic.project.bytebistro.culinarycraft.exception.UserAlreadyExistException;
import ic.project.bytebistro.culinarycraft.exception.UserNotFoundException;
import ic.project.bytebistro.culinarycraft.exception.UserUnauthorizedException;
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

}

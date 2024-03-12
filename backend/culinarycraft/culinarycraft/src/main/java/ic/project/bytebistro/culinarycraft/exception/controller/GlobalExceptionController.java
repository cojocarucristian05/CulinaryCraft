package ic.project.bytebistro.culinarycraft.exception.controller;

import ic.project.bytebistro.culinarycraft.exception.UserNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionController {

    @ExceptionHandler(value = UserNotFoundException.class)
    public ResponseEntity<String> handleUserNotFoundException(UserNotFoundException userNotFoundException) {
        return new ResponseEntity<>(userNotFoundException.getMessage(), HttpStatus.NOT_FOUND);
    }
}

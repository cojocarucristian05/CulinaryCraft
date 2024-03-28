package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.repository.entity.UserRegisterDTO;
import ic.project.bytebistro.culinarycraft.service.MailService;
import ic.project.bytebistro.culinarycraft.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/api/v1")
public class AuthController {

    private final UserService userService;

    private final MailService mailService;

    public AuthController(UserService userService, MailService mailService) {
        this.userService = userService;
        this.mailService = mailService;
    }

    @PostMapping("/register")
    public ResponseEntity<UserRegisterDTO> create(@RequestBody UserRegisterDTO userRegisterDTO) {
        UserRegisterDTO savedUser = userService.create(userRegisterDTO);
        CompletableFuture.runAsync(() -> mailService.sendWelcomeEmail(userRegisterDTO));
        return new ResponseEntity<>(savedUser, HttpStatus.CREATED);
    }
}

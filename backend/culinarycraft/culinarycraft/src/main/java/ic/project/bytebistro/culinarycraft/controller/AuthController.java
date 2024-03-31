package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginWithGoogleOrFacebookDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserRegisterRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.UserResponseDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.LoginType;
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
    public ResponseEntity<UserResponseDTO> create(@RequestBody UserRegisterRequestDTO userRegisterRequestDTO) {
        UserResponseDTO savedUser = userService.create(userRegisterRequestDTO);
        CompletableFuture.runAsync(() -> mailService.sendWelcomeEmail(userRegisterRequestDTO));
        return new ResponseEntity<>(savedUser, HttpStatus.CREATED);
    }

    @PostMapping("/login")
    public ResponseEntity<UserResponseDTO> login(@RequestBody UserLoginRequestDTO userLoginRequestDTO) {
        return new ResponseEntity<>(userService.login(userLoginRequestDTO), HttpStatus.OK);
    }

    @PostMapping("/sign-in-with-google")
    public ResponseEntity<UserResponseDTO> signInWithGoogle(@RequestBody UserLoginWithGoogleOrFacebookDTO userLoginWithGoogleOrFacebookDTO) {
        return new ResponseEntity<>(userService.signInWithGoogleOrFacebook(userLoginWithGoogleOrFacebookDTO, LoginType.GOOGLE), HttpStatus.OK);
    }

    @PostMapping("/sign-in-with-facebook")
    public ResponseEntity<UserResponseDTO> signInWithFacebook(@RequestBody UserLoginWithGoogleOrFacebookDTO userLoginWithGoogleOrFacebookDTO) {
        return new ResponseEntity<>(userService.signInWithGoogleOrFacebook(userLoginWithGoogleOrFacebookDTO, LoginType.FACEBOOK), HttpStatus.OK);
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<Void> forgotPassword(@RequestParam String email) {
        Long code = userService.forgotPassword(email);
        mailService.sendResetPasswordCode(email, code);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PostMapping("/verify-code")
    public ResponseEntity<Void> forgotPassword(@RequestParam Long userId, @RequestBody Long securityCode) {
        userService.verifySecurityCode(userId, securityCode);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping("/change-password")
    public ResponseEntity<Void> changePassword(@RequestParam Long userId, @RequestBody String newPassword) {
        userService.changePassword(userId, newPassword);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}

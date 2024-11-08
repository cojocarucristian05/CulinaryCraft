package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginWithGoogleOrFacebookDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserRegisterRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.ForgotPasswordDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.RegisterResponseDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.UserResponseDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.LoginType;
import ic.project.bytebistro.culinarycraft.service.MailService;
import ic.project.bytebistro.culinarycraft.service.UserService;
import jakarta.transaction.Transactional;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.concurrent.CompletableFuture;

@Transactional
@RestController
@RequestMapping("${apiVersion}")
public class AuthController {

    private final UserService userService;

    private final MailService mailService;

    public AuthController(UserService userService, MailService mailService) {
        this.userService = userService;
        this.mailService = mailService;
    }

    @PostMapping("/register")
    public ResponseEntity<RegisterResponseDTO> create(@RequestBody UserRegisterRequestDTO userRegisterRequestDTO) {
        RegisterResponseDTO savedUser = userService.create(userRegisterRequestDTO);
        if (savedUser.getIsReactivated()) {
            CompletableFuture.runAsync(() -> mailService.sendWelcomeBackEmail(userRegisterRequestDTO));
        } else {
            CompletableFuture.runAsync(() -> mailService.sendWelcomeEmail(userRegisterRequestDTO));
        }
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
    public ResponseEntity<Long> forgotPassword(@RequestParam String email) {
        ForgotPasswordDTO forgotPasswordDTO = userService.forgotPassword(email);
        Long code = forgotPasswordDTO.getSecurityCode();
        mailService.sendResetPasswordCode(email, code);
        return new ResponseEntity<>(forgotPasswordDTO.getUserId(), HttpStatus.OK);
    }

    @PostMapping("/verify-code")
    public ResponseEntity<Void> verifyCode(@RequestParam Long userId, @RequestBody Long securityCode) {
        userService.verifySecurityCode(userId, securityCode);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping("/change-password")
    public ResponseEntity<Void> changePassword(@RequestParam Long userId, @RequestBody String newPassword) {
        userService.changePassword(userId, newPassword);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping("/deactivate-account/{id}")
    public ResponseEntity<Void> deactivateAccount(@PathVariable Long id) {
        userService.deactivateAccount(id);
        CompletableFuture.runAsync(() -> mailService.sendDeactivateAccountEmail(userService.getEmail(id), userService.getUsername(id)));
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("/delete-account/{id}")
    public ResponseEntity<Void> deleteAccount(@PathVariable Long id) {
        String email = userService.getEmail(id);
        String username = userService.getUsername(id);
        userService.deleteAccount(id);
        CompletableFuture.runAsync(() -> mailService.sendDeleteAccountEmail(email, username));
        return new ResponseEntity<>(HttpStatus.OK);
    }
}

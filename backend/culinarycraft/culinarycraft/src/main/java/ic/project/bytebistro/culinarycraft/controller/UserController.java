package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.exception.NoOauth2AuthenticationException;
import ic.project.bytebistro.culinarycraft.repository.dto.UserDTO;
import ic.project.bytebistro.culinarycraft.service.UserService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/info")
    public String getUserInfo(Principal principal) {
        return "Info: " + principal.getName();
    }

    @GetMapping("/me")
    public Map<String, Object> userDetails(@AuthenticationPrincipal OAuth2User user) {
        if (user == null) {
            throw new NoOauth2AuthenticationException();
        }
        return user.getAttributes();
    }
}

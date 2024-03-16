package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.service.UserService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

}

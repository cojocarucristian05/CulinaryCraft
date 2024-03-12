package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.repository.dto.UserDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.User;
import ic.project.bytebistro.culinarycraft.service.UserService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/post")
    public UserDTO create(@RequestBody User user) {
        return userService.create(user);
    }

    @GetMapping("/get")
    public UserDTO read(@RequestParam Long id) {
        return userService.read(id);
    }

}

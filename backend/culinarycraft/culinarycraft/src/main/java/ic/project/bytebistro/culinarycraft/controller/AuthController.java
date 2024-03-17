package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.repository.entity.UserRegisterDTO;
import ic.project.bytebistro.culinarycraft.service.UserService;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

@RestController
public class AuthController {

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @RequestMapping("/api/v1/get_started")
    public ModelAndView getStartedTemplate() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("get_started_template");
        return modelAndView;
    }

    @RequestMapping("/api/v1/login_template")
    public ModelAndView getLoginTemplate() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("login");
        return modelAndView;
    }

    @RequestMapping("/api/v1/register_template")
    public ModelAndView registerTemplate() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("register");
        return modelAndView;
    }

    @RequestMapping("/api/v1/home")
    public ModelAndView home() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("home");
        return modelAndView;
    }

    @RequestMapping("/api/v1/register")
    @PostMapping
    public org.springframework.security.core.userdetails.User register(@RequestBody UserRegisterDTO userRegisterDTO) {
        return userService.registerNewUserAccount(userRegisterDTO);
    }

    @RequestMapping("/api/v1/dashboard")
    public ModelAndView dashboard() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("dashboard");
        return modelAndView;
    }
}

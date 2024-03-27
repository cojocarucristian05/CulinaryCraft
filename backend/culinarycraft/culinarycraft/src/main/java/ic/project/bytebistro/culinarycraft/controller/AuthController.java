package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.repository.entity.UserRegisterDTO;
import ic.project.bytebistro.culinarycraft.service.MailService;
import ic.project.bytebistro.culinarycraft.service.UserService;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.concurrent.CompletableFuture;

@RestController
public class AuthController {

    private final UserService userService;

    private final MailService mailService;

    public AuthController(UserService userService, MailService mailService) {
        this.userService = userService;
        this.mailService = mailService;
    }

    @RequestMapping("/api/v1/get_started")
    public ModelAndView getStartedTemplate() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("get_started");
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
        org.springframework.security.core.userdetails.User user = userService.registerNewUserAccount(userRegisterDTO);
        // Create a new thread to execute mailService.sendWelcomeEmail
        CompletableFuture.runAsync(() -> mailService.sendWelcomeEmail(userRegisterDTO));
        return user;
    }

    @RequestMapping("/api/v1/dashboard")
    public ModelAndView dashboard() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("dashboard");
        return modelAndView;
    }
}

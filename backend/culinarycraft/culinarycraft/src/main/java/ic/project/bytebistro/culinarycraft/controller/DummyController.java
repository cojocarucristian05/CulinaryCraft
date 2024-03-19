package ic.project.bytebistro.culinarycraft.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
public class DummyController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello world!";
    }

    @GetMapping("/hello/secured")
    public String helloSecured() {
        return "Hello world!";
    }

}

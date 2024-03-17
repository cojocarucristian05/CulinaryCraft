package ic.project.bytebistro.culinarycraft.config;

import ic.project.bytebistro.culinarycraft.repository.entity.CustomOAuth2User;
import ic.project.bytebistro.culinarycraft.repository.entity.UserRegisterDTO;
import ic.project.bytebistro.culinarycraft.service.UserService;
import ic.project.bytebistro.culinarycraft.service.implementation.CustomOAuth2UserService;
import ic.project.bytebistro.culinarycraft.service.implementation.UserServiceDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import static ic.project.bytebistro.culinarycraft.utils.PasswordGenerator.generatePassword;
import static ic.project.bytebistro.culinarycraft.utils.PasswordGenerator.hashPassword;
import static org.springframework.security.config.Customizer.withDefaults;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final UserServiceDetails userDetailsService;
    private final CustomOAuth2UserService oauthUserService;
    private final UserService userService;

    public SecurityConfig(UserServiceDetails userDetailsService, CustomOAuth2UserService oauthUserService, UserService userService) {
        this.userDetailsService = userDetailsService;
        this.oauthUserService = oauthUserService;
        this.userService = userService;
    }

    @Autowired
    protected void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService);
    }

    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
        return httpSecurity
                .authorizeHttpRequests( auth -> {
                    auth.requestMatchers("/api/v1/hello").permitAll();
                    auth.requestMatchers("/api/v1/get_started_template").permitAll();
                    auth.requestMatchers("/api/v1/login_template").permitAll();
                    auth.requestMatchers("/api/v1/register_template").permitAll();
                    auth.requestMatchers("/api/v1/login").permitAll();
                    auth.requestMatchers("/api/v1/register").permitAll();
                    auth.requestMatchers("/api/v1/users/post").permitAll();
                    auth.requestMatchers("/api/v1/users/get").permitAll();
                    auth.requestMatchers("/api/v1/dashboard").hasAuthority("ROLE_ADMIN");
                    auth.anyRequest().authenticated();
                })
                .httpBasic(withDefaults())
                .formLogin(form -> form
                        .loginPage("/api/v1/login_template")
                        .loginProcessingUrl("/api/v1/login")
                        .successForwardUrl("/api/v1/get_started_template")
                        .failureForwardUrl("/api/v1/login_template")
                        .permitAll()
                )
                .oauth2Login(oauth2 -> oauth2
                        .userInfoEndpoint(userInfo -> userInfo.userService(oauthUserService)).successHandler((request, response, authentication) -> {
                            CustomOAuth2User oauthUser = (CustomOAuth2User) authentication.getPrincipal();
                            //Here you call your service to save the user
                            System.out.println(">>>>>>>>>>>>>>>>>>Aici>>>>>>>>>>> " + oauthUser.getName().toLowerCase().replaceAll(" ", ""));
                            UserRegisterDTO userRegisterDTO = new UserRegisterDTO();
                            userRegisterDTO.setUsername(oauthUser.getName().toLowerCase().replaceAll(" ", ""));
                            userRegisterDTO.setEmail(oauthUser.getEmail());
                            userRegisterDTO.setPassword(hashPassword(generatePassword(12)));
                            userService.create(userRegisterDTO);
                            response.sendRedirect("/api/v1/home");
                        })
                        .failureHandler((request, response, authentication) -> {
                            response.sendRedirect("/api/v1/login_template");
                        })
                        .loginPage("/api/v1/login_template")
                )
                .csrf(AbstractHttpConfigurer::disable)
                .build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return NoOpPasswordEncoder.getInstance();
    }
}

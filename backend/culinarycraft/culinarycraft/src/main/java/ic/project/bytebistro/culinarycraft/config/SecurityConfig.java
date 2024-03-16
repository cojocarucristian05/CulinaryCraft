package ic.project.bytebistro.culinarycraft.config;

import ic.project.bytebistro.culinarycraft.service.implementation.UserServiceDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import static org.springframework.security.config.Customizer.withDefaults;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final UserServiceDetails userDetailsService;

    public SecurityConfig(UserServiceDetails userDetailsService) {
        this.userDetailsService = userDetailsService;
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
                .oauth2Login(withDefaults())
                .formLogin(withDefaults())
                .csrf(AbstractHttpConfigurer::disable)
                .build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return NoOpPasswordEncoder.getInstance();
    }
}

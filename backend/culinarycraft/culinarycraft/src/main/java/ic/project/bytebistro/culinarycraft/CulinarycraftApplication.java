package ic.project.bytebistro.culinarycraft;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@SpringBootApplication
public class CulinarycraftApplication {

	@Bean
	CorsConfigurationSource corsConfigurationSource() {
		CorsConfiguration configuration = new CorsConfiguration();
		configuration.setAllowedOrigins(Arrays.asList(
				"http://localhost:8080/api/v1/register",
				"http://localhost:8080/api/v1/login",
				"http://localhost:8080/api/v1/sign-in-with-google",
				"http://localhost:8080/api/v1/sign-in-with-facebook"
		));
		configuration.setAllowedMethods(Arrays.asList("POST"));
		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
		source.registerCorsConfiguration("/**", configuration);
		return source;
	}

	public static void main(String[] args) {
		SpringApplication.run(CulinarycraftApplication.class, args);
	}

}

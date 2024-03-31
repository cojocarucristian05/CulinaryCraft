package ic.project.bytebistro.culinarycraft.repository.dto.request;

import lombok.Data;

@Data
public class UserLoginWithGoogleOrFacebookDTO {
    private String username;
    private String email;
}

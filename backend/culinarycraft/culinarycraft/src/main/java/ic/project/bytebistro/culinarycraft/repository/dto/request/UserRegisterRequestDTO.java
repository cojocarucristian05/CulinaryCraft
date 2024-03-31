package ic.project.bytebistro.culinarycraft.repository.dto.request;

import lombok.Data;

@Data
public class UserRegisterRequestDTO {
    private String username;
    private String email;
    private String password;
}

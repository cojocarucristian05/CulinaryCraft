package ic.project.bytebistro.culinarycraft.repository.dto.request;

import lombok.Data;

@Data
public class UserLoginRequestDTO {
    private String username;
    private String password;
}

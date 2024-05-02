package ic.project.bytebistro.culinarycraft.repository.dto.response;

import lombok.Data;

@Data
public class RegisterResponseDTO {
    private Long id;
    private String username;
    private String email;
    private Boolean isReactivated;
}

package ic.project.bytebistro.culinarycraft.repository.dto.response;

import lombok.Data;

@Data
public class ForgotPasswordDTO {
    private Long securityCode;
    private Long userId;
}

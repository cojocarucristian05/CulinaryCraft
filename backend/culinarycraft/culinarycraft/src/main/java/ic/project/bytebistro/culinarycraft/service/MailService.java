package ic.project.bytebistro.culinarycraft.service;

import ic.project.bytebistro.culinarycraft.repository.dto.request.UserRegisterRequestDTO;

public interface MailService {
     void sendWelcomeEmail(UserRegisterRequestDTO userRegisterRequestDTO);

     void sendResetPasswordCode(String email, Long code);
}

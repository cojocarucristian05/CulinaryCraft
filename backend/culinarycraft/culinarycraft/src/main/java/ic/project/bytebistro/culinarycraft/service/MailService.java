package ic.project.bytebistro.culinarycraft.service;

import ic.project.bytebistro.culinarycraft.repository.dto.request.UserRegisterRequestDTO;

public interface MailService {
     void sendWelcomeEmail(UserRegisterRequestDTO userRegisterRequestDTO);
     void sendWelcomeBackEmail(UserRegisterRequestDTO userRegisterRequestDTO);
     void sendResetPasswordCode(String email, Long code);
     void sendDeactivateAccountEmail(String email, String username);
     void sendDeleteAccountEmail(String email, String username);
}

package ic.project.bytebistro.culinarycraft.service;

import ic.project.bytebistro.culinarycraft.repository.entity.UserRegisterDTO;

public interface MailService {
    public void sendWelcomeEmail(UserRegisterDTO userRegisterDTO);
}

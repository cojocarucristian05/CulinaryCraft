package ic.project.bytebistro.culinarycraft.service.implementation;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserRegisterRequestDTO;
import ic.project.bytebistro.culinarycraft.service.MailService;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

@Service
public class MailServiceImpl implements MailService {
    private final Configuration configuration;

    @Value("${spring.mail.username}")
    private String adminEmail;
    @Value("${spring.mail.password}")
    private String password;

    @Value("${spring.constants.companyName}")
    private String companyName = "Culinary Craft";

    public MailServiceImpl(Configuration configuration) {
        this.configuration = configuration;
    }

    @Override
    public void sendWelcomeEmail(UserRegisterRequestDTO userRegisterRequestDTO) {
        MimeMessage message = new MimeMessage(getSession());
        try {
            MimeMessageHelper helper = new MimeMessageHelper(
                    message,
                    MimeMessageHelper.MULTIPART_MODE_MIXED_RELATED,
                    StandardCharsets.UTF_8.name());
            helper.setFrom(new InternetAddress(adminEmail));
            helper.setTo(userRegisterRequestDTO.getEmail());
            helper.setSubject("Welcome to " + companyName);
            Template template  = configuration.getTemplate("welcome.html");
            Map<String, Object> templateMapper = new HashMap<>();
            templateMapper.put("username", userRegisterRequestDTO.getUsername());
            templateMapper.put("adminEmail", adminEmail);
            templateMapper.put("companyName", companyName);
            String htmlTemplate = FreeMarkerTemplateUtils.processTemplateIntoString(template, templateMapper);
            helper.setText(htmlTemplate, true);
            Transport.send(message);
        } catch (MessagingException | IOException | TemplateException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void sendResetPasswordCode(String email, Long code) {
        MimeMessage message = new MimeMessage(getSession());
        try {
            MimeMessageHelper helper = new MimeMessageHelper(
                    message,
                    MimeMessageHelper.MULTIPART_MODE_MIXED_RELATED,
                    StandardCharsets.UTF_8.name());
            helper.setFrom(new InternetAddress(adminEmail));
            helper.setTo(email);
            helper.setSubject("Welcome to " + companyName);
            Template template = configuration.getTemplate("send-code.html");
            Map<String, Object> templateMapper = new HashMap<>();
            templateMapper.put("code", code);
            String htmlTemplate = FreeMarkerTemplateUtils.processTemplateIntoString(template, templateMapper);
            helper.setText(htmlTemplate, true);
            Transport.send(message);
        } catch (MessagingException | IOException | TemplateException e) {
            throw new RuntimeException(e);
        }
    }

    private Properties getProperties() {
        Properties properties = System.getProperties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.ssl.trust", "*");
        return properties;
    }

    private Session getSession() {
        Properties properties = getProperties();
        return Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(adminEmail, password);
            }
        });
    }
}

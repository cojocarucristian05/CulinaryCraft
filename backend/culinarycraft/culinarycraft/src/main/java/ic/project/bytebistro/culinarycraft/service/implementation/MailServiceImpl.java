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

    private final String COMPANY_NAME = "Culinary Craft";
    private final String WELCOME_SUBJECT = "Welcome to " + COMPANY_NAME;
    private final String WELCOME_BACK_SUBJECT = "Welcome back to " + COMPANY_NAME;
    private final String DELETE_ACCOUNT_SUBJECT = "Account Deleted Successfully";
    private final String DEACTIVATE_ACCOUNT_SUBJECT = "Account Deactivation Notification";
    private final String SEND_SECURITY_CODE_SUBJECT = "Reset password security code";
    private final String WELCOME_TEMPLATE = "welcome.html";
    private final String WELCOME_BACK_TEMPLATE = "welcome-back.html";
    private final String DELETE_ACCOUNT_TEMPLATE = "delete-account.html";
    private final String DEACTIVATE_ACCOUNT_TEMPLATE = "deactivate-account.html";
    private final String SEND_SECURITY_CODE_TEMPLATE = "send-code.html";

    public MailServiceImpl(Configuration configuration) {
        this.configuration = configuration;
    }

    @Override
    public void sendWelcomeEmail(UserRegisterRequestDTO userRegisterRequestDTO) {
        sendWelcomeMailHelper(userRegisterRequestDTO, WELCOME_TEMPLATE, WELCOME_SUBJECT);
    }

    @Override
    public void sendWelcomeBackEmail(UserRegisterRequestDTO userRegisterRequestDTO) {
        sendWelcomeMailHelper(userRegisterRequestDTO, WELCOME_BACK_TEMPLATE, WELCOME_BACK_SUBJECT);
    }

    @Override
    public void sendResetPasswordCode(String email, Long code) {
        MimeMessage message = new MimeMessage(getSession());
        try {
            MimeMessageHelper helper = getMessageHelper(message);
            helper.setFrom(new InternetAddress(adminEmail));
            helper.setTo(email);
            helper.setSubject(SEND_SECURITY_CODE_SUBJECT);
            Template template = configuration.getTemplate(SEND_SECURITY_CODE_TEMPLATE);
            Map<String, Object> templateMapper = new HashMap<>();
            templateMapper.put("code", code);
            String htmlTemplate = FreeMarkerTemplateUtils.processTemplateIntoString(template, templateMapper);
            helper.setText(htmlTemplate, true);
            Transport.send(message);
        } catch (MessagingException | IOException | TemplateException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void sendDeactivateAccountEmail(String email, String username) {
        deleteAccountHelper(email, username, DEACTIVATE_ACCOUNT_SUBJECT, DEACTIVATE_ACCOUNT_TEMPLATE);
    }

    @Override
    public void sendDeleteAccountEmail(String email, String username) {
        deleteAccountHelper(email, username, DELETE_ACCOUNT_SUBJECT, DELETE_ACCOUNT_TEMPLATE);
    }

    private void deleteAccountHelper(String email, String username, String subject, String templateName) {
        MimeMessage message = new MimeMessage(getSession());
        try {
            MimeMessageHelper helper = getMessageHelper(message);
            helper.setFrom(new InternetAddress(adminEmail));
            helper.setTo(email);
            helper.setSubject(subject);
            Template template = configuration.getTemplate(templateName);
            Map<String, Object> templateMapper = new HashMap<>();
            templateMapper.put("username", username);
            String htmlTemplate = FreeMarkerTemplateUtils.processTemplateIntoString(template, templateMapper);
            helper.setText(htmlTemplate, true);
            Transport.send(message);
        } catch (MessagingException | IOException | TemplateException e) {
            throw new RuntimeException(e);
        }
    }


    private void sendWelcomeMailHelper(UserRegisterRequestDTO userRegisterRequestDTO, String templateName,
                                       String subject) {
        MimeMessage message = new MimeMessage(getSession());
        try {
            MimeMessageHelper helper = getMessageHelper(message);
            helper.setFrom(new InternetAddress(adminEmail));
            helper.setTo(userRegisterRequestDTO.getEmail());
            helper.setSubject(subject);
            Template template  = configuration.getTemplate(templateName);
            Map<String, Object> templateMapper = new HashMap<>();
            templateMapper.put("username", userRegisterRequestDTO.getUsername());
            templateMapper.put("adminEmail", adminEmail);
            templateMapper.put("companyName", COMPANY_NAME);
            String htmlTemplate = FreeMarkerTemplateUtils.processTemplateIntoString(template, templateMapper);
            helper.setText(htmlTemplate, true);
            Transport.send(message);
        } catch (MessagingException | IOException | TemplateException e) {
            throw new RuntimeException(e);
        }
    }

    private static MimeMessageHelper getMessageHelper(MimeMessage message) throws MessagingException {
        return new MimeMessageHelper(
                message,
                MimeMessageHelper.MULTIPART_MODE_MIXED_RELATED,
                StandardCharsets.UTF_8.name());
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

package com.tsinjo.book_borrow.email;

import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.thymeleaf.spring6.SpringTemplateEngine;

@Service
@RequiredArgsConstructor
public class EmailService {
    private final JavaMailSender mailSender;
    private final SpringTemplateEngine templateEngine;

    //there are something to be added

    public void sendEmail(
            String to,
            String username,
            EmailTemplate emailTemplate,
            String confirmationUrS,
            String activationCode,
            String subject
    ){
        String templateName;
        if (emailTemplate == null){
           templateName="Confirm-mail"
        }else {
            templateName = emailTemplate.name();
        }

        MimeMessage mimeMessage = mailSender.createMimeMessage();
    }


}

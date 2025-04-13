//package com.tsinjo.book_borrow.email;
//
//import jakarta.mail.MessagingException;
//import jakarta.mail.internet.MimeMessage;
//import lombok.RequiredArgsConstructor;
//import org.springframework.mail.javamail.JavaMailSender;
//import org.springframework.mail.javamail.MimeMessageHelper;
//import org.springframework.scheduling.annotation.Async;
//import org.springframework.stereotype.Service;
//import org.thymeleaf.spring6.SpringTemplateEngine;
//import org.thymeleaf.context.Context;
//
//import java.util.HashMap;
//import java.util.Map;
//
//@Service
//@RequiredArgsConstructor
//public class EmailService {
//    private final JavaMailSender mailSender;
//    private final SpringTemplateEngine templateEngine;
//
//    //there are something to be added
//
//    @Async
//    public void sendEmail(
//            String to,
//            String username,
//            EmailTemplate emailTemplate,
//            String confirmationUrS,
//            String activationCode,
//            String subject
//    ) throws MessagingException {
//        String templateName;
//        if (emailTemplate == null){
//           templateName="Confirm-mail";
//        }else {
//            templateName = emailTemplate.name();
//        }
//
//        MimeMessage mimeMessage = mailSender.createMimeMessage();
//        MimeMessageHelper helper = new MimeMessageHelper(
//                mimeMessage,
//                MimeMessageHelper.MULTIPART_MODE_MIXED_RELATED,
//                "UTF-8"
//        );
//        Map<String, Object> properties = new HashMap<>();
//        properties.put("username", username);
//        properties.put("confirmationUrl", confirmationUrS);
//        properties.put("activationCode", activationCode);
//
//
//        Context context = new Context();
//        context.setVariables(properties);
//        helper.setFrom("contact@tsinjo@gmail.com");
//        helper.setTo(to);
//        helper.setTo(subject);
//
//
//        String template = templateEngine.process(templateName, context);
//        helper.setText(template, true);
//        mailSender.send(mimeMessage);
//    }
//
//
//}

package com.tsinjo.book_borrow.email;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.thymeleaf.spring6.SpringTemplateEngine;
import org.thymeleaf.context.Context;

import java.nio.charset.StandardCharsets; // Bonne pratique pour l'encodage
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class EmailService {
    private final JavaMailSender mailSender;
    private final SpringTemplateEngine templateEngine;

    // Si vous souhaitez externaliser l'adresse 'from', ajoutez ceci et la propriété dans application.yml:
    // @Value("${spring.mail.properties.mail.from}")
    // private String fromAddress;

    @Async
    public void sendEmail(
            String to,
            String username,
            EmailTemplate emailTemplate,
            String confirmationUrl, // Nom de variable légèrement amélioré
            String activationCode,
            String subject
    ) throws MessagingException {
        String templateName;
        if (emailTemplate == null){
            // Attention: Cette branche ne devrait normalement pas être atteinte si vous passez toujours ACTIVATE_ACCOUNT
            // Si elle l'est, assurez-vous qu'un template "confirm-mail.html" existe ou gérez l'erreur.
            // Le template principal est "activate-account.html".
            templateName="activate_account"; // Nom du fichier html
        } else {
            // Utiliser la méthode qui retourne le nom du fichier template défini dans l'enum
            templateName = emailTemplate.getTemplateName(); // CORRIGÉ: Utilise la valeur ("activate-account")
        }

        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(
                mimeMessage,
                MimeMessageHelper.MULTIPART_MODE_MIXED_RELATED,
                StandardCharsets.UTF_8.name() // Utiliser StandardCharsets pour l'encodage
        );
        Map<String, Object> properties = new HashMap<>();
        properties.put("username", username);
        properties.put("confirmationUrl", confirmationUrl); // Utiliser le nom de variable mis à jour
        properties.put("activationCode", activationCode);


        Context context = new Context();
        context.setVariables(properties);

        // --- CORRECTION 1: Adresse 'From' ---
        // Remplacer l'adresse invalide par une adresse au format correct.
        // Pour MailDev, l'adresse n'a pas besoin d'exister, mais le format doit être valide.
        // Utilisez une adresse générique ou configurez-la via application.yml (voir @Value ci-dessus).
        helper.setFrom("no-reply@book-borrow.com"); // CORRIGÉ: Adresse valide (exemple)

        helper.setTo(to); // Destinataire - OK

        // --- CORRECTION 2: Sujet ---
        // Utiliser setSubject pour définir le sujet de l'email.
        helper.setSubject(subject); // CORRIGÉ


        String template = templateEngine.process(templateName, context);
        helper.setText(template, true);
        mailSender.send(mimeMessage);
    }


}

package com.tsinjo.book_borrow.authentication;

import com.tsinjo.book_borrow.email.EmailService;
import com.tsinjo.book_borrow.email.EmailTemplate;
import com.tsinjo.book_borrow.role.RoleRepository;
import com.tsinjo.book_borrow.security.JwtService;
import com.tsinjo.book_borrow.user.Token;
import com.tsinjo.book_borrow.user.TokenRepository;
import com.tsinjo.book_borrow.user.User;
import com.tsinjo.book_borrow.user.UserRepository;
import jakarta.mail.MessagingException;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import lombok.Builder;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.security.SecureRandom;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;


@Service
@RequiredArgsConstructor
public class AuthenticationService {
    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository;
    private final TokenRepository tokenRepository;
    private final EmailService emailService;
    @Value("${application.mailing.frontend.activation-url}")
    private String activationUrl;
    private final RoleRepository roleRepository;
   private final AuthenticationManager authenticationManager;
   private final JwtService jwtService;


    public void register(RegistrationRequest request) throws MessagingException {
        var userRole = roleRepository.findByName("USER")
                .orElseThrow(() -> new IllegalStateException("THe role user should initialized"));
        var user = User.builder()
                .firstname(request.getFirstname())
                .lastname(request.getLastname())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .accountLocked(false)
                .enable(false)
                .roles(List.of(userRole))
                .build();
        userRepository.save(user);
        sendValidationEmail(user);


    }

    private void sendValidationEmail(User user) throws MessagingException {
        var newToken =generateAndSaveActivationToken(user);
        //send the email
        emailService.sendEmail(
                user.getEmail(),
                user.fullName(),
                EmailTemplate.ACTIVATE_ACCOUNT,
                activationUrl,
                newToken,
                "Activate your account"
        );
    }

    private String generateAndSaveActivationToken(User user) {
        //generate the token
        String generateToken = generateAndSaveActivationCode(6);
        var token = Token.builder()
                .token(generateToken)
                .createdAt(LocalDateTime.now())
                .expiresAt(LocalDateTime.now().plusMinutes(15))
                .user(user)
                .build();
        tokenRepository.save(token);
        return generateToken;
    }



    private String generateAndSaveActivationCode(int length) {
        String characters = "0123456789";
        SecureRandom secureRandom = new SecureRandom();
        StringBuilder activationCode = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int randomIndex = secureRandom.nextInt(characters.length());
            activationCode.append(characters.charAt(randomIndex));
        }
        return activationCode.toString();
    }

    public AuthenticationResponse authenticate(@Valid AuthenticationRequest request) {
        var auth = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );
        var claims = new HashMap<String,Object>();
        var user = ((User) auth.getPrincipal());
        claims.put("fullName", user.fullName());
        var jwtToken = jwtService.generateToken(claims, user);
        return AuthenticationResponse .builder()
                .token(jwtToken)
                .build();

    }

//    @Transactional
    public void activateAccount(String token) throws MessagingException {
        Token savedToken = tokenRepository.findByToken(token)
                .orElseThrow(() -> new RuntimeException("Token not found"));
        if (LocalDateTime.now().isAfter(savedToken.getExpiresAt())) {
            sendValidationEmail(savedToken.getUser());
            throw  new RuntimeException("the activation token has expired ,the ne token will be sent to your email address");
        }
        var user = userRepository.findById(savedToken.getUser().getId())
                .orElseThrow(() -> new RuntimeException("User not found"));
        user.setEnable(true);
        userRepository.save(user);
        savedToken.setValidatedAt(LocalDateTime.now());
        tokenRepository.save(savedToken);
    }
}


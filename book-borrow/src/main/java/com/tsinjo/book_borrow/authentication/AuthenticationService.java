package com.tsinjo.book_borrow.authentication;

import com.tsinjo.book_borrow.role.RoleRepository;
import com.tsinjo.book_borrow.user.Token;
import com.tsinjo.book_borrow.user.TokenRepository;
import com.tsinjo.book_borrow.user.User;
import com.tsinjo.book_borrow.user.UserRepository;
import lombok.Builder;
import lombok.RequiredArgsConstructor;
import org.hibernate.validator.cfg.defs.EmailDef;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.security.SecureRandom;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Builder
public class AuthenticationService {
    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository;
    private final TokenRepository tokenRepository;


    private RoleRepository roleRepository;
    public void register(RegistrationRequest request) {
        var userRole = roleRepository.findByName("USER")
                .orElseThrow(() -> new IllegalStateException("THe role user should initialized"));
        var user = User.builder()
                .firstname(request.getFirstname())
                .lastname(request.getLastname())
                .email(request.getPassword())
                .password(passwordEncoder.encode(request.getPassword()))
                .accountLocked(false)
                .enable(false)
                .roles(List.of(userRole))
                .build();
        userRepository.save(user);
        sendValidationEmail(user);


    }

    private void sendValidationEmail(User user) {
        var newToken =generateAndSaveActivationToken(user);
        //send the email
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
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        SecureRandom secureRandom = new SecureRandom();
        StringBuilder activationCode = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int randomIndex = secureRandom.nextInt(characters.length());
            activationCode.append(characters.charAt(randomIndex));
        }
        return activationCode.toString();
    }
}


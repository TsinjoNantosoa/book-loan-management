package com.tsinjo.book_borrow.authentication;

import com.tsinjo.book_borrow.role.RoleRepository;
import com.tsinjo.book_borrow.user.User;
import lombok.Builder;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Builder
public class AuthenticationService {
    private RoleRepository roleRepository;
    public void register(RegistrationRequest request) {
        var userRole = roleRepository.findByName("USER")
                .orElseThrow(() -> new IllegalStateException("THe role user should initialized"));
        var user = User.builder()
                .firstname(request.getFirstname())
                .lastname(request.getLastname())
                .email(request.getPassword())
                .password("")
                .accountLocked(false)
                .enable(false)
                .roles(List.of(userRole))
                .build();

    }

}


package com.tsinjo.book_borrow.security;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher; // Import si nécessaire

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
@EnableMethodSecurity(securedEnabled = true)
public class ConfigSecurity {
    private final JwtFilter jwtAuthFilter;
    private final AuthenticationProvider authenticationProvider;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .cors(Customizer.withDefaults())
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(req ->
                        req.requestMatchers(
                                        // Chemins SANS le context-path /api/v1
                                        AntPathRequestMatcher.antMatcher("/auth/**"), // Plus explicite
                                        // Ou simplement "/auth/**"
                                        AntPathRequestMatcher.antMatcher("/v2/api-docs"),
                                        AntPathRequestMatcher.antMatcher("/v3/api-docs"),
                                        AntPathRequestMatcher.antMatcher("/v3/api-docs/**"),
                                        AntPathRequestMatcher.antMatcher("/swagger-resources"),
                                        AntPathRequestMatcher.antMatcher("/swagger-resources/**"),
                                        AntPathRequestMatcher.antMatcher("/configuration/ui"), // Pas besoin de /** ici en général
                                        AntPathRequestMatcher.antMatcher("/configuration/security"),
                                        AntPathRequestMatcher.antMatcher("/swagger-ui/**"),
                                        AntPathRequestMatcher.antMatcher("/webjars/**"),
                                        AntPathRequestMatcher.antMatcher("/swagger-ui.html")
                                ).permitAll()
                                .anyRequest().authenticated() // Toutes les autres requêtes nécessitent une authentification
                )
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authenticationProvider(authenticationProvider)
                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }
}
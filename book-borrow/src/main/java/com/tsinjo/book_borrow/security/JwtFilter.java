package com.tsinjo.book_borrow.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Service;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
public class JwtFilter extends OncePerRequestFilter {

    private final JwtService jwtService;
    private final UserDetailsService userDetailsService;
    private static final Logger logger = LoggerFactory.getLogger(JwtFilter.class);

    // Define public paths that should bypass JWT validation
    // Note: Use startsWith for matching, so ensure paths don't have trailing slashes if not intended
    private static final List<String> PUBLIC_PATHS = Arrays.asList(
            "/api/v1/auth",
            "/api/v1/v2/api-docs",
            "/api/v1/v3/api-docs",          // Base path for api-docs v3
            "/api/v1/swagger-resources",    // Base path for swagger resources
            "/api/v1/configuration/ui",
            "/api/v1/configuration/security",
            "/api/v1/swagger-ui",           // Base path for swagger UI
            "/api/v1/webjars",              // Webjars resources used by swagger UI
            "/api/v1/swagger-ui.html"       // Specific file for swagger UI
    );


    @Override
    protected void doFilterInternal(@NotNull HttpServletRequest request,
                                    @NotNull HttpServletResponse response,
                                    @NotNull FilterChain filterChain
    ) throws ServletException, IOException {

        final String requestURI = request.getRequestURI();

        // Check if the path is public (should bypass JWT check)
        boolean isPublicPath = PUBLIC_PATHS.stream().anyMatch(path -> requestURI.startsWith(path));

        if (isPublicPath) {
             logger.debug("Request URI {} is public, bypassing JWT check.", requestURI);
            filterChain.doFilter(request, response); // Let the request through without JWT check
            return;
        }

        logger.debug("Request URI {} is secured, proceeding with JWT check.", requestURI);
        final String authHeader = request.getHeader("Authorization");
        final String jwt;
        final String userEmail;

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
             logger.debug("No Bearer token found in Authorization header for secured path {}.", requestURI);
            // For secured paths, if no valid Bearer token, let Spring Security handle potential 403
            filterChain.doFilter(request, response);
            return;
        }

        jwt = authHeader.substring(7);
        try {
            userEmail = jwtService.extractUserName(jwt);
            logger.debug("Extracted username '{}' from JWT.", userEmail);
        } catch (Exception e) {
            // Handle potential exceptions during token parsing (expired, malformed, etc.)
             logger.warn("Error extracting username from JWT: {}", e.getMessage()); // Corrected warn usage
             filterChain.doFilter(request, response); // Let Spring Security handle it (likely results in 403)
             return;
        }


        if (userEmail != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            logger.debug("User '{}' not yet authenticated, loading details.", userEmail);
            UserDetails userDetails = userDetailsService.loadUserByUsername(userEmail);
            // Validate token
            try {
                if (jwtService.isTokenValid(jwt, userDetails)) {
                    logger.debug("JWT token is valid for user '{}'. Setting authentication context.", userEmail);
                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                            userDetails,
                            null, // Credentials can be null for JWT
                            userDetails.getAuthorities()
                    );
                    authToken.setDetails(
                            new WebAuthenticationDetailsSource().buildDetails(request)
                    );
                    // Set authentication in context
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                } else {
                     logger.warn("JWT token validation failed for user '{}'.", userEmail);
                }
             } catch (Exception e) {
                 // Handle potential exceptions during token validation
                 logger.warn("Exception during JWT validation for user '{}': {}", userEmail, e.getMessage()); // Corrected warn usage
                 // Do not set authentication, let the filter chain continue
             }
        } else if (userEmail == null) {
             logger.warn("Could not extract username from JWT, although Bearer token was present.");
        } else {
             logger.debug("User '{}' already authenticated.", userEmail);
        }

        filterChain.doFilter(request, response);
    }
}

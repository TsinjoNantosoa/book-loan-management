//package com.tsinjo.book_borrow.config;
//
//import org.springframework.data.domain.AuditorAware;
//import org.springframework.security.core.Authentication;
//import org.springframework.security.core.context.SecurityContextHolder;
//
//import java.util.Optional;
//
//public class ApplicationAuditAware implements AuditorAware<Integer> {
//    @Override
//    public Optional<Integer> getCurrentAuditor() {
//        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
//        if (authentication == null) {
//
//        }
//        return Optional.empty();
//    }
//}

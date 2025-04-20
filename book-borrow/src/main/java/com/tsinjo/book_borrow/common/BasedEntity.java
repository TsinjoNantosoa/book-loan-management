//package com.tsinjo.book_borrow.common;
//
//import jakarta.persistence.*;
//import lombok.AllArgsConstructor;
//import lombok.Getter;
//import lombok.NoArgsConstructor;
//import lombok.Setter;
//import lombok.experimental.SuperBuilder;
//import org.springframework.data.annotation.CreatedBy;
//import org.springframework.data.annotation.CreatedDate;
//import org.springframework.data.annotation.LastModifiedBy;
//import org.springframework.data.annotation.LastModifiedDate;
//import org.springframework.data.jpa.domain.support.AuditingEntityListener;
//
//import java.time.LocalDateTime;
//
//@Getter
//@Setter
//@SuperBuilder
//@NoArgsConstructor
//@AllArgsConstructor
//@MappedSuperclass
//@EntityListeners(AuditingEntityListener.class)
//public class BasedEntity {
//    @Id
//    @GeneratedValue
//    private Integer id;
//
//    @CreatedDate
//    @Column(insertable = false, updatable = false)
//    private LocalDateTime createdDate;
//
//    @LastModifiedDate
//    @Column(insertable = false)
//    private LocalDateTime lastModifiedDate;
//
//    @CreatedBy
//    @Column(nullable = false, updatable = false)
//    private Integer createBy;
//
//    @LastModifiedBy
//    @Column(insertable = false)
//    private Integer lastModifiedBy;
//
//    public Integer getCreateBy() {
//        return createBy;
//    }
//
//    public void setCreateBy(Integer createBy) {
//        this.createBy = createBy;
//    }
//
//    public Integer getLastModifiedBy() {
//        return lastModifiedBy;
//    }
//
//    public void setLastModifiedBy(Integer lastModifiedBy) {
//        this.lastModifiedBy = lastModifiedBy;
//    }
//
//    public LocalDateTime getLastModifiedDate() {
//        return lastModifiedDate;
//    }
//
//    public void setLastModifiedDate(LocalDateTime lastModifiedDate) {
//        this.lastModifiedDate = lastModifiedDate;
//    }
//
//    public LocalDateTime getCreatedDate() {
//        return createdDate;
//    }
//
//    public void setCreatedDate(LocalDateTime createdDate) {
//        this.createdDate = createdDate;
//    }
//
//    public Integer getId() {
//        return id;
//    }
//
//    public void setId(Integer id) {
//        this.id = id;
//    }
//
//
//}

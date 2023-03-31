package ving.vingterview.domain;

import jakarta.persistence.MappedSuperclass;

import java.time.LocalDateTime;

@MappedSuperclass
public abstract class EntityDate {

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}

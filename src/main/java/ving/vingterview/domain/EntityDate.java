package ving.vingterview.domain;

import jakarta.persistence.MappedSuperclass;
import lombok.Getter;

import java.time.LocalDateTime;

@MappedSuperclass
@Getter
public abstract class EntityDate {

    private LocalDateTime createTime;
    private LocalDateTime updateTime;


}

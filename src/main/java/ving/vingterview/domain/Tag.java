package ving.vingterview.domain;

import jakarta.persistence.*;
import lombok.Getter;

@Entity
@Getter
public class Tag {

    @Id
    @GeneratedValue
    @Column(name = "tag_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private Tag parent;
    private String name;

    @Enumerated(EnumType.STRING)
    private TagType category;
}

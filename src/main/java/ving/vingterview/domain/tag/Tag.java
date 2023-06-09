package ving.vingterview.domain.tag;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ving.vingterview.dto.tag.TagDTO;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Tag {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "tag_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private Tag parent;
    private String name;

    @Enumerated(EnumType.STRING)
    private TagType category;

    @Builder
    public Tag(Tag parent, String name, TagType category) {
        this.parent = parent;
        this.name = name;
        this.category = category;
    }
}

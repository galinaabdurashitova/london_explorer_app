package org.example.api_users.model;

import jakarta.persistence.*;

import java.sql.Timestamp;

@Entity
@Table(name = "friends")
public class Friend {
    @Id
    @Column(name = "friendship_id", length = 36)
    private String friendshipId;

    @Column(name = "user_1_id", length = 28, nullable = false)
    private String user1Id;

    @Column(name = "user_2_id", length = 28, nullable = false)
    private String user2Id;

    @Column(name = "friendship_date")
    private Timestamp friendshipDate;

    public Friend() {
        // Empty constructor needed for JPA
    }

    public Friend(String friendshipId, String user1Id, String user2Id, Timestamp friendshipDate) {
        this.friendshipId = friendshipId;
        this.user1Id = user1Id;
        this.user2Id = user2Id;
        this.friendshipDate = friendshipDate;
    }

    // Getters and Setters

    public String getFriendshipId() {
        return friendshipId;
    }

    public void setFriendshipId(String friendshipId) {
        this.friendshipId = friendshipId;
    }

    public String getUser1Id() {
        return user1Id;
    }

    public void setUser1Id(String user1Id) {
        this.user1Id = user1Id;
    }

    public String getUser2Id() {
        return user2Id;
    }

    public void setUser2Id(String user2Id) {
        this.user2Id = user2Id;
    }

    public Timestamp getFriendshipDate() {
        return friendshipDate;
    }

    public void setFriendshipDate(Timestamp friendshipDate) {
        this.friendshipDate = friendshipDate;
    }
}

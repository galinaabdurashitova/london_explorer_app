package org.example.api_users.dto;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class FriendUpdateResponse {
    private String userId;
    private String imageName;
    private String name;
    private String userName;
    private Timestamp updateDate;
    private String updateType;
    private String description;

    public FriendUpdateResponse(String userId, String imageName, String name, String userName, Timestamp updateDate, String updateType, String description) {
        this.userId = userId;
        this.imageName = imageName;
        this.name = name;
        this.userName = userName;
        this.updateDate = updateDate;
        this.updateType = updateType;
        this.description = description;
    }

    public String getUserId() { return this.userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getImageName() { return this.imageName; }
    public void setImageName(String imageName) { this.imageName = imageName; }

    public String getName() { return this.name; }
    public void setName(String name) { this.name = name; }

    public String getUserName() { return this.userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public Timestamp getUpdateDate() { return this.updateDate; }
    public void setUpdateDate(Timestamp updateDate) { this.updateDate = updateDate; }

    public String getUpdateType() { return this.updateType; }
    public void setUpdateType(String updateType) { this.updateType = updateType; }

    public String getDescription() { return this.description; }
    public void setDescription(String description) { this.description = description; }
}

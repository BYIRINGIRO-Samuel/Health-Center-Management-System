package com.pms.model;

import java.util.Date;

public class NotificationItem {
    private String type;
    private String title;
    private String message;
    private Date time;
    private boolean unread;
    private String tagText;
    private String tagBgColor;
    private String tagTextColor;

    public NotificationItem(String type, String title, String message, Date time, boolean unread, String tagText, String tagBgColor, String tagTextColor) {
        this.type = type;
        this.title = title;
        this.message = message;
        this.time = time;
        this.unread = unread;
        this.tagText = tagText;
        this.tagBgColor = tagBgColor;
        this.tagTextColor = tagTextColor;
    }

    public String getType() { return type; }
    public String getTitle() { return title; }
    public String getMessage() { return message; }
    public Date getTime() { return time; }
    public boolean isUnread() { return unread; }
    public String getTagText() { return tagText; }
    public String getTagBgColor() { return tagBgColor; }
    public String getTagTextColor() { return tagTextColor; }
}

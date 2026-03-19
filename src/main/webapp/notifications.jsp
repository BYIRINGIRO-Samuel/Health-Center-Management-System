<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String role = user.getRole();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications | PMS Health</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/topbar.css">
    <style>
        .notif-page-wrapper { max-width: 760px; margin: 0 auto; }
        .notif-filter-tabs { display: flex; gap: 0.5rem; margin-bottom: 1.5rem; }
        .notif-filter-tab {
            padding: 0.45rem 1.1rem; border-radius: 20px; border: none;
            font-size: 0.82rem; font-weight: 600; cursor: pointer;
            background: var(--white); color: var(--text-muted);
            border: 1.5px solid var(--border-color); transition: all 0.2s;
        }
        .notif-filter-tab.active, .notif-filter-tab:hover {
            background: var(--teal-primary); color: white; border-color: var(--teal-primary);
        }
        .notif-list { display: flex; flex-direction: column; gap: 0.75rem; }
        .notif-item {
            background: var(--white); border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 1.25rem 1.5rem;
            display: flex; align-items: flex-start; gap: 1rem;
            border-left: 4px solid transparent;
            transition: all 0.2s ease; cursor: pointer;
            position: relative;
        }
        .notif-item.unread { border-left-color: var(--teal-primary); background: var(--teal-soft); }
        .notif-item:hover { transform: translateX(4px); box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
        .notif-icon {
            width: 44px; height: 44px; border-radius: 12px; flex-shrink: 0;
            display: flex; align-items: center; justify-content: center;
        }
        .notif-icon svg { width: 22px; height: 22px; }
        .notif-icon.type-appointment { background: #dbeafe; color: #3b82f6; }
        .notif-icon.type-payment    { background: #dcfce7; color: #16a34a; }
        .notif-icon.type-alert      { background: #fef3c7; color: #d97706; }
        .notif-icon.type-system     { background: #f3e8ff; color: #9333ea; }
        .notif-icon.type-medical    { background: var(--teal-soft); color: var(--teal-primary); }
        .notif-body { flex: 1; min-width: 0; }
        .notif-body h4 { font-size: 0.95rem; font-weight: 700; color: var(--text-dark); margin-bottom: 0.25rem; }
        .notif-body p  { font-size: 0.85rem; color: var(--text-muted); line-height: 1.5; margin: 0; }
        .notif-meta { display: flex; align-items: center; gap: 0.75rem; margin-top: 0.5rem; }
        .notif-time { font-size: 0.75rem; color: var(--text-muted); }
        .notif-tag  { font-size: 0.7rem; font-weight: 700; padding: 0.15rem 0.6rem; border-radius: 20px; }
        .notif-unread-dot {
            position: absolute; top: 1rem; right: 1rem;
            width: 8px; height: 8px; border-radius: 50%; background: var(--teal-primary);
        }
        .notif-empty { text-align: center; padding: 4rem 2rem; }
        .notif-empty svg { width: 64px; height: 64px; color: var(--border-color); margin: 0 auto 1rem; display: block; }
        .notif-empty h3 { color: var(--text-muted); font-size: 1.1rem; }
        .notif-header-actions { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.25rem; }
        .mark-all-read { background: none; border: none; color: var(--teal-primary); font-weight: 600; font-size: 0.85rem; cursor: pointer; }
        .mark-all-read:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="dashboard-layout">
        <jsp:include page="components/sidebar.jsp" />

        <main class="main-content" style="padding-top: 0;">
            <jsp:include page="components/topbar.jsp" />

            <div class="main-inner-content">
                <div class="notif-page-wrapper">
                    <div class="page-title" style="margin-bottom: 1.5rem;">
                        <h1>Notifications</h1>
                        <p class="text-muted">Stay up to date with your health center activity</p>
                    </div>

                    <div class="notif-header-actions">
                        <div class="notif-filter-tabs">
                            <button class="notif-filter-tab active" onclick="filterNotifs(this, 'all')">All</button>
                            <button class="notif-filter-tab" onclick="filterNotifs(this, 'unread')">Unread</button>
                            <button class="notif-filter-tab" onclick="filterNotifs(this, 'appointment')">Appointments</button>
                            <button class="notif-filter-tab" onclick="filterNotifs(this, 'payment')">Payments</button>
                        </div>
                        <button class="mark-all-read" onclick="markAllRead()">Mark all as read</button>
                    </div>

                    <div class="notif-list" id="notifList">
                        <%@ page import="java.util.List, com.pms.model.NotificationItem" %>
                        <%
                            List<NotificationItem> notifList = (List<NotificationItem>) request.getAttribute("notificationsList");
                            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy 'at' hh:mm a");
                            if (notifList != null && !notifList.isEmpty()) {
                                for(NotificationItem notif : notifList) {
                                    String iconHtml = "";
                                    if("appointment".equals(notif.getType())) {
                                        iconHtml = "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><rect x=\"3\" y=\"4\" width=\"18\" height=\"18\" rx=\"2\" ry=\"2\"/><line x1=\"16\" y1=\"2\" x2=\"16\" y2=\"6\"/><line x1=\"8\" y1=\"2\" x2=\"8\" y2=\"6\"/><line x1=\"3\" y1=\"10\" x2=\"21\" y2=\"10\"/></svg>";
                                    } else if("payment".equals(notif.getType())) {
                                        iconHtml = "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><line x1=\"12\" y1=\"1\" x2=\"12\" y2=\"23\"/><path d=\"M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6\"/></svg>";
                                    } else if("medical".equals(notif.getType())) {
                                        iconHtml = "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z\"/></svg>";
                                    } else if("system".equals(notif.getType())) {
                                        iconHtml = "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><circle cx=\"12\" cy=\"12\" r=\"10\"/><line x1=\"12\" y1=\"8\" x2=\"12\" y2=\"12\"/><line x1=\"12\" y1=\"16\" x2=\"12.01\" y2=\"16\"/></svg>";
                                    } else {
                                        iconHtml = "<svg viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z\"/><line x1=\"12\" y1=\"9\" x2=\"12\" y2=\"13\"/><line x1=\"12\" y1=\"17\" x2=\"12.01\" y2=\"17\"/></svg>";
                                    }
                        %>
                        <div class="notif-item <%= notif.isUnread() ? "unread" : "" %>" data-type="<%= notif.getType() %>">
                            <div class="notif-icon type-<%= notif.getType() %>">
                                <%= iconHtml %>
                            </div>
                            <div class="notif-body">
                                <h4><%= notif.getTitle() %></h4>
                                <p><%= notif.getMessage() %></p>
                                <div class="notif-meta">
                                    <span class="notif-time">⏱ <%= notif.getTime() != null ? sdf.format(notif.getTime()) : "Just now" %></span>
                                    <span class="notif-tag" style="background:<%= notif.getTagBgColor() %>;color:<%= notif.getTagTextColor() %>;"><%= notif.getTagText() %></span>
                                </div>
                            </div>
                            <% if(notif.isUnread()) { %>
                                <div class="notif-unread-dot"></div>
                            <% } %>
                        </div>
                        <% 
                                }
                            } else {
                        %>
                        <div class="notif-empty" style="text-align: center; padding: 4rem 2rem;">
                            <svg style="width: 64px; height: 64px; color: var(--border-color); margin: 0 auto 1rem; display: block;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
                            <h3 style="color: var(--text-muted); font-size: 1.1rem; margin-bottom: 0.5rem;">No notifications</h3>
                            <p style="color: var(--border-color);">You're all caught up!</p>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
    function filterNotifs(btn, type) {
        document.querySelectorAll('.notif-filter-tab').forEach(function(t) { t.classList.remove('active'); });
        btn.classList.add('active');
        document.querySelectorAll('.notif-item').forEach(function(item) {
            if (type === 'all') {
                item.style.display = 'flex';
            } else if (type === 'unread') {
                item.style.display = item.classList.contains('unread') ? 'flex' : 'none';
            } else {
                item.style.display = (item.dataset.type === type) ? 'flex' : 'none';
            }
        });
    }
    function markAllRead() {
        fetch('NotificationActionServlet?action=markAllRead')
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    document.querySelectorAll('.notif-item.unread').forEach(function(item) {
                        item.classList.remove('unread');
                        var dot = item.querySelector('.notif-unread-dot');
                        if (dot) dot.remove();
                    });
                    // Update badge
                    var badge = document.getElementById('notifBadge');
                    if (badge) { badge.textContent = '0'; badge.style.display = 'none'; }
                }
            });
    }
    </script>
</body>
</html>

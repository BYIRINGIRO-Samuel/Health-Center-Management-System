<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pms.model.User, com.pms.model.Appointment, com.pms.model.Billing, java.util.List" %>
<%@ page import="com.pms.dao.PatientDAO, com.pms.dao.PatientDAOImpl, com.pms.dao.DoctorDAO, com.pms.dao.DoctorDAOImpl" %>
<%@ page import="com.pms.dao.ReceptionistDAO, com.pms.dao.ReceptionistDAOImpl, com.pms.dao.AdminDAO, com.pms.dao.AdminDAOImpl" %>
<%
    User topbarUser = (User) session.getAttribute("user");
    String tbName = (topbarUser != null) ? topbarUser.getFullName() : "Guest";
    String tbRole = (topbarUser != null) ? topbarUser.getRole() : "";
    String tbInitial = (tbName != null && !tbName.isEmpty()) ? String.valueOf(tbName.charAt(0)).toUpperCase() : "?";
    
    // Compute unread count based on actual DB pending items
    int unreadCount = 0;
    if (topbarUser != null) {
        java.util.Date lastCheck = topbarUser.getLastNotifCheck();
        if (lastCheck == null) {
            // If never checked, use a very old date
            lastCheck = new java.util.Date(0); 
        }

        if ("Patient".equals(tbRole)) {
            PatientDAO pDao = new PatientDAOImpl();
            for(Appointment a : pDao.getAppointmentsByPatientId(topbarUser.getId())) {
                if ("Scheduled".equals(a.getStatus())) {
                    java.util.Date created = a.getCreatedAt();
                    if (created != null && created.after(lastCheck)) unreadCount++;
                }
            }
            for(Billing b : pDao.getBillingsByPatientId(topbarUser.getId())) {
                if ("Pending".equals(b.getStatus())) {
                    java.util.Date bDate = b.getBillingDate();
                    if (bDate != null && bDate.after(lastCheck)) unreadCount++;
                }
            }
        } else if ("Doctor".equals(tbRole)) {
            DoctorDAO dDao = new DoctorDAOImpl();
            for(Appointment a : dDao.getAppointmentsForDoctor(topbarUser.getId())) {
                if ("Scheduled".equals(a.getStatus())) {
                    java.util.Date created = a.getCreatedAt();
                    if (created != null && created.after(lastCheck)) unreadCount++;
                }
            }
        } else if ("Receptionist".equals(tbRole)) {
            ReceptionistDAO rDao = new ReceptionistDAOImpl();
            for(Billing b : rDao.getAllBillings()) {
                if ("Pending".equals(b.getStatus())) {
                    java.util.Date bDate = b.getBillingDate();
                    if (bDate != null && bDate.after(lastCheck)) unreadCount++;
                }
            }
        } else if ("Admin".equals(tbRole)) {
            AdminDAO aDao = new AdminDAOImpl();
            List<Object[]> acts = aDao.getRecentActivity();
            if(acts != null) {
                for(Object[] log : acts) {
                    java.util.Date logDate = null;
                    if (log[2] instanceof java.util.Date) logDate = (java.util.Date) log[2];
                    if (logDate != null && logDate.after(lastCheck)) unreadCount++;
                }
            }
        }
    }

    // Build profile URL based on role
    String profileUrl = "settings.jsp";
    String notifUrl   = "NotificationServlet?action=list";
    if ("Patient".equals(tbRole)) {
        notifUrl   = "PatientServlet?action=notifications";
    } else if ("Doctor".equals(tbRole)) {
        notifUrl   = "DoctorServlet?action=notifications";
    } else if ("Admin".equals(tbRole)) {
        notifUrl   = "AdminServlet?action=notifications";
    } else if ("Receptionist".equals(tbRole)) {
        notifUrl   = "ReceptionistServlet?action=notifications";
    }

    // Role display label
    String roleLabel = tbRole;
    if ("Admin".equals(tbRole))        roleLabel = "System Administrator";
    else if ("Doctor".equals(tbRole))  roleLabel = "Physician";
    else if ("Receptionist".equals(tbRole)) roleLabel = "Front Desk";
    else if ("Patient".equals(tbRole)) roleLabel = "Patient";
%>

<!-- ===== TOP NAVIGATION BAR ===== -->
<header class="portal-topbar">

    <!-- Left: Page title slot (filled by outer page via data attribute or just brand) -->
    <div class="topbar-left">
        <div class="topbar-brand">
            <div class="topbar-brand-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                </svg>
            </div>
            <div class="topbar-brand-text">
                <span class="topbar-page-title" id="topbarPageTitle">PMS Health</span>
                <span class="topbar-breadcrumb"><%= tbRole %> Portal</span>
            </div>
        </div>
    </div>

    <!-- Right: Notification + Profile -->
    <div class="topbar-right">

        <!-- Notification Bell -->
        <a href="<%= notifUrl %>" class="topbar-icon-btn" id="notifBtn" title="Notifications">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
            </svg>
            <% if (unreadCount > 0) { %>
                <span class="notif-badge" id="notifBadge"><%= unreadCount %></span>
            <% } else { %>
                <span class="notif-badge" id="notifBadge" style="display:none;">0</span>
            <% } %>
        </a>

        <!-- Divider -->
        <div class="topbar-divider"></div>

        <!-- Profile Area -->
        <div class="topbar-profile" id="topbarProfileBtn">
            <div class="topbar-avatar">
                <%= tbInitial %>
                <div class="topbar-avatar-ring"></div>
            </div>
            <div class="topbar-user-info">
                <span class="topbar-user-name"><%= tbName %></span>
                <span class="topbar-user-role topbar-role-<%= tbRole %>"><%= roleLabel %></span>
            </div>
            <svg class="topbar-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="6 9 12 15 18 9"></polyline>
            </svg>

            <!-- Dropdown Menu -->
            <div class="topbar-dropdown" id="topbarDropdown">
                <div class="topbar-dropdown-header">
                    <div class="topbar-drop-avatar"><%= tbInitial %></div>
                    <div>
                        <p class="topbar-drop-name"><%= tbName %></p>
                        <p class="topbar-drop-role"><%= roleLabel %></p>
                    </div>
                </div>
                <hr class="topbar-drop-divider">
                <a href="<%= profileUrl %>" class="topbar-drop-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"/></svg>
                    Account Settings
                </a>
                <a href="<%= notifUrl %>" class="topbar-drop-item">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
                    Notifications
                </a>
                <hr class="topbar-drop-divider">
                <a href="LogoutServlet" class="topbar-drop-item topbar-drop-logout">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                    Sign Out
                </a>
            </div>
        </div>
    </div>
</header>

<script>
(function() {
    // Profile dropdown toggle
    var profileBtn = document.getElementById('topbarProfileBtn');
    var dropdown   = document.getElementById('topbarDropdown');
    if (profileBtn && dropdown) {
        profileBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            dropdown.classList.toggle('open');
            profileBtn.classList.toggle('active');
        });
        document.addEventListener('click', function() {
            dropdown.classList.remove('open');
            profileBtn.classList.remove('active');
        });
    }

    // Auto-set page title from <h1> or <title>
    var titleEl = document.getElementById('topbarPageTitle');
    if (titleEl) {
        var h1 = document.querySelector('.page-title h1') || document.querySelector('main h1');
        if (h1) {
            titleEl.textContent = h1.textContent.trim();
        } else {
            var docTitle = document.title.split('|')[0].trim();
            if (docTitle) titleEl.textContent = docTitle;
        }
    }
})();
</script>

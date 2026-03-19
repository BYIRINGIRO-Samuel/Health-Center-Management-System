$files = @(
    "src/main/java/com/pms/model/Billing.java",
    "src/main/java/com/pms/model/Appointment.java",
    "src/main/java/com/pms/model/User.java",
    "src/main/resources/META-INF/persistence.xml",
    "src/main/java/com/pms/dao/ReceptionistDAO.java",
    "src/main/java/com/pms/dao/ReceptionistDAOImpl.java",
    "src/main/java/com/pms/controller/ReceptionistServlet.java",
    "src/main/webapp/components/sidebar.jsp",
    "src/main/webapp/receptionist-dashboard.jsp",
    "src/main/webapp/manage-patients-reception.jsp",
    "src/main/webapp/book-appointment.jsp",
    "src/main/webapp/receptionist-appointments.jsp",
    "src/main/webapp/receptionist-billing.jsp"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Adding and committing: $file"
        git add $file
        $basename = Split-Path $file -Leaf
        git commit -m "Receptionist Portal: integration of $basename"
        git push
        Write-Host "Pushed $file. Waiting 3 minutes..."
        Start-Sleep -Seconds 180
    } else {
        Write-Host "Warning: File $file not found!"
    }
}

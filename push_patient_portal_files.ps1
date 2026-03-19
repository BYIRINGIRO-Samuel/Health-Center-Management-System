$files = @(
    "src/main/java/com/pms/dao/PatientDAO.java",
    "src/main/java/com/pms/dao/PatientDAOImpl.java",
    "src/main/java/com/pms/controller/PatientServlet.java",
    "src/main/java/com/pms/controller/LoginServlet.java",
    "src/main/java/com/pms/controller/SignupServlet.java",
    "src/main/webapp/WEB-INF/web.xml",
    "src/main/webapp/patient-dashboard.jsp",
    "src/main/webapp/patient-profile.jsp",
    "src/main/webapp/patient-book-appointment.jsp",
    "src/main/webapp/patient-appointments.jsp",
    "src/main/webapp/patient-medical-history.jsp",
    "src/main/webapp/patient-prescriptions.jsp",
    "src/main/webapp/patient-payment-history.jsp"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Adding and committing: $file"
        git add $file
        $basename = Split-Path $file -Leaf
        git commit -m "Patient Portal: integration of $basename"
        git push
        Write-Host "Pushed $file. Waiting 1 minute..."
        Start-Sleep -Seconds 60
    } else {
        Write-Host "Warning: File $file not found!"
    }
}

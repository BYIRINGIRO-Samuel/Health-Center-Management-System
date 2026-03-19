$files = @(
    "src/main/webapp/css/folder-cards.css",
    "src/main/webapp/patient-dashboard.jsp",
    "src/main/webapp/receptionist-dashboard.jsp",
    "src/main/webapp/doctor-dashboard.jsp",
    "src/main/webapp/admin-dashboard.jsp",
    "src/main/webapp/payments.jsp",
    "src/main/webapp/doctor-appointments.jsp",
    "src/main/webapp/patient-medical-history.jsp",
    "src/main/webapp/patient-prescriptions.jsp",
    "src/main/webapp/patient-payment-history.jsp",
    "src/main/webapp/patient-profile.jsp",
    "src/main/webapp/patient-book-appointment.jsp",
    "src/main/webapp/patient-appointments.jsp"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Adding and committing: $file"
        git add $file
        $basename = Split-Path $file -Leaf
        git commit -m "UI Update: fix JSP tags and folder cards for $basename"
        git push
        Write-Host "Pushed $file. Waiting 1 minute..."
        Start-Sleep -Seconds 60
    } else {
        Write-Host "Warning: File $file not found!"
    }
}

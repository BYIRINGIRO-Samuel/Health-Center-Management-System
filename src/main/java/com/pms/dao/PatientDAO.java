package com.pms.dao;

import com.pms.model.Appointment;
import com.pms.model.Billing;
import com.pms.model.MedicalRecord;
import com.pms.model.Prescription;
import com.pms.model.User;
import java.util.List;

public interface PatientDAO {
    List<Appointment> getAppointmentsByPatientId(Long patientId);
    List<MedicalRecord> getMedicalRecordsByPatientId(Long patientId);
    List<Prescription> getPrescriptionsByPatientId(Long patientId);
    List<Billing> getBillingsByPatientId(Long patientId);
    void bookAppointment(Appointment appointment);
    void updateProfile(User user);
    User getPatientById(Long id);
    List<User> getAllDoctors();
    void payBilling(Long billingId, String paymentMethod);
}

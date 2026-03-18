package com.pms.dao;

import com.pms.model.Appointment;
import com.pms.model.Billing;
import com.pms.model.User;
import java.util.List;

public interface ReceptionistDAO {
    void registerPatient(User patient);
    List<User> getAllPatients();
    void bookAppointment(Appointment appointment);
    List<Appointment> getAllAppointments();
    void updateAppointmentStatus(Long appointmentId, String status);
    void createBilling(Billing billing);
    List<Billing> getAllBillings();
    void updateBillingStatus(Long billingId, String status);
}

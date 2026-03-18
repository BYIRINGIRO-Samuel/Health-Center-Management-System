package com.pms.dao;

import com.pms.model.Appointment;
import com.pms.model.MedicalRecord;
import com.pms.model.Prescription;
import com.pms.model.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import com.pms.util.HibernateUtil;
import java.util.List;

public class DoctorDAOImpl implements DoctorDAO {
    private EntityManagerFactory emf = HibernateUtil.getEntityManagerFactory();

    @Override
    public List<Appointment> getAppointmentsForDoctor(Long doctorId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT a FROM Appointment a WHERE a.doctor.id = :did ORDER BY a.dateTime ASC", Appointment.class)
                    .setParameter("did", doctorId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> getPatientsForDoctor(Long doctorId) {
        EntityManager em = emf.createEntityManager();
        try {
            // Distinct patients who have appointments with this doctor
            return em.createQuery("SELECT DISTINCT a.patient FROM Appointment a WHERE a.doctor.id = :did", User.class)
                    .setParameter("did", doctorId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void createMedicalRecord(MedicalRecord record) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(record);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    @Override
    public List<MedicalRecord> getPatientHistory(Long patientId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT m FROM MedicalRecord m WHERE m.patient.id = :pid ORDER BY m.recordDate DESC", MedicalRecord.class)
                    .setParameter("pid", patientId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void writePrescription(Prescription prescription) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(prescription);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Prescription> getPrescriptionsForPatient(Long patientId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT p FROM Prescription p WHERE p.patient.id = :pid ORDER BY p.datePrescribed DESC", Prescription.class)
                    .setParameter("pid", patientId)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}

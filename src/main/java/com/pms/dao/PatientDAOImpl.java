package com.pms.dao;

import com.pms.model.Appointment;
import com.pms.model.Billing;
import com.pms.model.MedicalRecord;
import com.pms.model.Prescription;
import com.pms.model.User;
import com.pms.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import java.util.List;

public class PatientDAOImpl implements PatientDAO {

    private EntityManagerFactory emf = HibernateUtil.getEntityManagerFactory();

    @Override
    public List<Appointment> getAppointmentsByPatientId(Long patientId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT a FROM Appointment a WHERE a.patient.id = :patientId ORDER BY a.appointmentDate DESC", Appointment.class)
                    .setParameter("patientId", patientId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<MedicalRecord> getMedicalRecordsByPatientId(Long patientId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT m FROM MedicalRecord m WHERE m.patient.id = :patientId ORDER BY m.recordDate DESC", MedicalRecord.class)
                    .setParameter("patientId", patientId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Prescription> getPrescriptionsByPatientId(Long patientId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT p FROM Prescription p WHERE p.patient.id = :patientId ORDER BY p.datePrescribed DESC", Prescription.class)
                    .setParameter("patientId", patientId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Billing> getBillingsByPatientId(Long patientId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT b FROM Billing b WHERE b.patient.id = :patientId ORDER BY b.billingDate DESC", Billing.class)
                    .setParameter("patientId", patientId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void bookAppointment(Appointment appointment) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(appointment);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    @Override
    public void updateProfile(User user) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(user);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    @Override
    public User getPatientById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> getAllDoctors() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u WHERE u.role = 'Doctor'", User.class).getResultList();
        } finally {
            em.close();
        }
    }
}

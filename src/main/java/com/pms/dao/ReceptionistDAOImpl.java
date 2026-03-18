package com.pms.dao;

import com.pms.model.Appointment;
import com.pms.model.Billing;
import com.pms.model.User;
import com.pms.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import java.util.List;

public class ReceptionistDAOImpl implements ReceptionistDAO {
    private EntityManagerFactory emf = HibernateUtil.getEntityManagerFactory();

    @Override
    public void registerPatient(User patient) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(patient);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> getAllPatients() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u WHERE u.role = 'Patient'", User.class).getResultList();
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
        } finally {
            em.close();
        }
    }

    @Override
    public List<Appointment> getAllAppointments() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT a FROM Appointment a ORDER BY a.appointmentDate DESC", Appointment.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void updateAppointmentStatus(Long appointmentId, String status) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Appointment a = em.find(Appointment.class, appointmentId);
            if (a != null) {
                a.setStatus(status);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    @Override
    public void createBilling(Billing billing) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(billing);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Billing> getAllBillings() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT b FROM Billing b ORDER BY b.billingDate DESC", Billing.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void updateBillingStatus(Long billingId, String status) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Billing b = em.find(Billing.class, billingId);
            if (b != null) {
                b.setStatus(status);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}

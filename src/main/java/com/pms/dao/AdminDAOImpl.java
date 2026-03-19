package com.pms.dao;

import com.pms.model.Appointment;
import com.pms.model.Billing;
import com.pms.model.User;
import com.pms.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import java.util.*;
import java.util.*;

public class AdminDAOImpl implements AdminDAO {

    private EntityManagerFactory emf = HibernateUtil.getEntityManagerFactory();

    @Override
    public long getTotalPatients() {
        EntityManager em = emf.createEntityManager();
        try {
            return (long) em.createQuery("SELECT COUNT(u) FROM User u WHERE u.role = 'Patient'").getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public long getTotalDoctors() {
        EntityManager em = emf.createEntityManager();
        try {
            return (long) em.createQuery("SELECT COUNT(u) FROM User u WHERE u.role = 'Doctor'").getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public long getTotalAppointments() {
        EntityManager em = emf.createEntityManager();
        try {
            return (long) em.createQuery("SELECT COUNT(a) FROM Appointment a").getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public double getTotalRevenue() {
        EntityManager em = emf.createEntityManager();
        try {
            Double revenue = (Double) em.createQuery("SELECT SUM(b.amount) FROM Billing b").getSingleResult();
            return revenue != null ? revenue : 0.0;
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> getAllUsers() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u", User.class).getResultList();
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
    public List<User> getAllDoctors() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u WHERE u.role = 'Doctor'", User.class).getResultList();
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
    public List<Billing> getAllBillings() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT b FROM Billing b ORDER BY b.billingDate DESC", Billing.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Object[]> getRecentActivity() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createNativeQuery("SELECT 'New Appointment' as activity, p.fullName as userName, a.appointmentDate as timestamp, a.status as status " +
                                       "FROM appointments a JOIN users p ON a.patient_id = p.id " +
                                       "UNION ALL " +
                                       "SELECT 'New Signup' as activity, fullName as userName, CURRENT_TIMESTAMP as timestamp, role as status FROM users " +
                                       "ORDER BY timestamp DESC")
                     .setMaxResults(10)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<com.pms.model.Department> getAllDepartments() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT d FROM Department d", com.pms.model.Department.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void addDepartment(com.pms.model.Department dept) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(dept);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    @Override
    public void deleteDepartment(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            com.pms.model.Department d = em.find(com.pms.model.Department.class, id);
            if (d != null) em.remove(d);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
    @Override
    public java.util.Map<String, Long> getMonthlyPatientGrowth() {
        EntityManager em = emf.createEntityManager();
        try {
            List<java.util.Date> dates = em.createQuery("SELECT u.createdAt FROM User u WHERE u.role = 'Patient'", java.util.Date.class).getResultList();
            java.util.Map<String, Long> growth = new java.util.LinkedHashMap<>();
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM");
            
            // Initialize last 5 months with 0
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.add(java.util.Calendar.MONTH, -4);
            for(int i = 0; i < 5; i++) {
                growth.put(sdf.format(cal.getTime()), 0L);
                cal.add(java.util.Calendar.MONTH, 1);
            }
            
            for(java.util.Date d : dates) {
                if (d != null) {
                    String month = sdf.format(d);
                    if(growth.containsKey(month)) {
                        growth.put(month, growth.get(month) + 1);
                    }
                }
            }
            return growth;
        } finally {
            em.close();
        }
    }

    @Override
    public java.util.Map<String, Double> getRevenueByDepartment() {
        EntityManager em = emf.createEntityManager();
        try {
            List<Object[]> results = em.createQuery(
                "SELECT d.name, SUM(b.amount) FROM Billing b " +
                "JOIN b.appointment a " +
                "JOIN a.doctor doc " +
                "JOIN doc.department d " +
                "GROUP BY d.name", Object[].class).getResultList();
            
            java.util.Map<String, Double> revenue = new java.util.HashMap<>();
            for(Object[] res : results) {
                revenue.put((String)res[0], (Double)res[1]);
            }
            return revenue;
        } finally {
            em.close();
        }
    }
}

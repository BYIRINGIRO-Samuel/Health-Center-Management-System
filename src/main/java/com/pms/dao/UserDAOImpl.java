package com.pms.dao;

import com.pms.model.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;

public class UserDAOImpl implements UserDAO {

    private EntityManagerFactory emf;

    public UserDAOImpl() {
        // "pmsPU" should match the persistence-unit name in META-INF/persistence.xml
        emf = Persistence.createEntityManagerFactory("pmsPU");
    }

    @Override
    public void registerUser(User user) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(user);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            throw e; // Optionally handle better
        } finally {
            em.close();
        }
    }

    @Override
    public User authenticateUser(String email, String password) {
        EntityManager em = emf.createEntityManager();
        try {
            List<User> users = em.createQuery("SELECT u FROM User u WHERE u.email = :email AND u.password = :password", User.class)
                    .setParameter("email", email)
                    .setParameter("password", password) // In production, hash the password
                    .getResultList();
            
            if (users != null && !users.isEmpty()) {
                return users.get(0);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return null;
    }
}

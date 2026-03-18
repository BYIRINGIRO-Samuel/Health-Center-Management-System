package com.pms.dao;

import com.pms.model.Department;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;

public class DepartmentDAOImpl implements DepartmentDAO {

    private EntityManagerFactory emf;

    public DepartmentDAOImpl() {
        emf = Persistence.createEntityManagerFactory("pmsPU");
    }

    @Override
    public void addDepartment(Department dept) {
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
    public List<Department> getAllDepartments() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT d FROM Department d", Department.class).getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void deleteDepartment(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Department d = em.find(Department.class, id);
            if (d != null) em.remove(d);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    @Override
    public void updateDepartment(Department dept) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(dept);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    @Override
    public Department getDepartmentById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Department.class, id);
        } finally {
            em.close();
        }
    }
}

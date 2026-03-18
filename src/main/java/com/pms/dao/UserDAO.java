package com.pms.dao;

import java.util.List;
import com.pms.model.User;

public interface UserDAO {
    void registerUser(User user);
    User authenticateUser(String email, String password);
    List<User> getAllUsers();
    void deleteUser(Long id);
    void updateUser(User user);
    User getUserById(Long id);
}

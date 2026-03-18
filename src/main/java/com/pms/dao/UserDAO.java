package com.pms.dao;

import com.pms.model.User;

public interface UserDAO {
    void registerUser(User user);
    User authenticateUser(String email, String password);
}

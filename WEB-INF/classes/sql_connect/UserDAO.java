/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sql_connect;

import sql_connect.UserBean;
import java.text.*;
import java.util.*;
import java.sql.*;

public class UserDAO {
        
    static Connection currentCon = null;
    static ResultSet rs = null;  
    public static UserBean login(UserBean bean) {

        Statement stmt = null;    
        String username = bean.getUsername();    
        String password = bean.getPassword();   

        String searchQuery = "select * from users where username='"
            + username
            + "' AND password='"
            + password
            + "'";
        try 
        {
            currentCon = ConnectionManager.getConnection();
            stmt=currentCon.createStatement();
            rs = stmt.executeQuery(searchQuery);	        
            boolean more = rs.next();
            if (!more) {
                System.out.println("Sorry, you are not a registered user! Please sign up first");
                bean.setValid(false);
            } 
            else if (more) {
                String firstName = rs.getString("FirstName");
                String lastName = rs.getString("LastName");
                System.out.println("Welcome " + firstName);
                bean.setFirstName(firstName);
                bean.setLastName(lastName);
                bean.setValid(true);
            }
        } 
        catch (Exception ex) 
        {
            System.out.println("Log In failed: An Exception has occurred! " + ex);
        } 
        finally 
        {
            if (rs != null) {
                try 
                {
                    rs.close();
                } 
                catch (Exception e) {}
                rs = null;
            }
            if (stmt != null) {
                try 
                {
                   stmt.close();
                } 
                catch (Exception e) {}
                stmt = null;
            }
            if (currentCon != null) {
                try 
                {
                    currentCon.close();
                } 
                catch (Exception e) {}
                currentCon = null;
            }
        }
        return bean;
    }	
}
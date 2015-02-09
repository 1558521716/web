/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sql_connect;

import java.sql.*;
import java.util.*;

    public class ConnectionManager {

        static Connection con = null;
        static String url;
            
        public static Connection getConnection(){
            try{
                Class.forName("com.mysql.jdbc.Driver");
                try{            	
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysql","root","root"); 
                    System.out.println("con is:"+con);
                }
                catch (SQLException ex){
                    ex.printStackTrace();
                }
            }
            catch(ClassNotFoundException e){
                System.out.println(e);
            }
            System.out.println("!!!!!!!!!!!!!!!!!!!!");
            return con;
        }
   }


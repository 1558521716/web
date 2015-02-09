package sql_connect;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import static sql_connect.EnterWishData.currentCon;

public class GetWishDataServlet extends HttpServlet {

    static Connection currentCon = null;
    static ResultSet rs = null;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Statement stmt = null;
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            currentCon = ConnectionManager.getConnection();
            stmt = currentCon.createStatement();
        }
        catch (Exception e2) {System.out.println(e2);}
    }
}
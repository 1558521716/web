package sql_connect;
import sql_connect.UserBean;
import static sql_connect.UserDAO.currentCon;
import java.io.*;
import java.sql.*;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.*;
  
public class EnterWishData extends HttpServlet {
    
    static Connection currentCon = null;
    static ResultSet rs = null;
    
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {  
        Statement stmt = null;
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        double wish_x = Double.parseDouble(request.getParameter("wish_x"));
        double wish_y = Double.parseDouble(request.getParameter("wish_y"));
        String wish_title= new String(request.getParameter("wish_title").getBytes("iso-8859-1"), "UTF-8");        
        String wish_text= new String(request.getParameter("wish_text").getBytes("iso-8859-1"), "UTF-8");
        String usernames=   request.getParameter("username");
        java.util.Date wish_date = new java.util.Date();
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String wish_time = sdf.format(wish_date);
        
        System.out.println(wish_x+"***"+wish_y+"***"+wish_title+"***"+wish_text+"***"+wish_time + "***"+ usernames);
        try
        {
            currentCon = ConnectionManager.getConnection();
            stmt = currentCon.createStatement();
            rs = stmt.executeQuery("select * from users where username='" + usernames + "'");
                PreparedStatement ps=currentCon.prepareStatement("insert into wishes values(?,?,?,?,?,?)");  
                ps.setDouble(1,wish_x);
                ps.setDouble(2,wish_y);
                ps.setString(3,wish_title);
                ps.setString(4,wish_text);
                ps.setString(5,usernames);
                ps.setString(6,wish_time);
                ps.executeUpdate();
                response.sendRedirect("index.jsp");
        }catch (Exception e2) {System.out.println(e2);}
    out.close();
    }
}
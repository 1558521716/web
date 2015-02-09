/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sql_connect;
import sql_connect.UserBean;
import static sql_connect.UserDAO.currentCon;
import java.io.*;  
import java.sql.*;  
import javax.servlet.ServletException;  
import javax.servlet.http.*;  
  
public class Register extends HttpServlet { 
    
    static Connection currentCon = null;
    static ResultSet rs = null;  

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {  
        Statement stmt = null;    
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();  
        String name=new String(request.getParameter("FirstName").getBytes("iso-8859-1"), "UTF-8");
        String surname=new String(request.getParameter("LastName").getBytes("iso-8859-1"), "UTF-8");;  
        String mails=new String(request.getParameter("Email").getBytes("iso-8859-1"), "UTF-8");;  
        String usernames=new String(request.getParameter("usermame").getBytes("iso-8859-1"), "UTF-8");;
        String passwords=new String(request.getParameter("password").getBytes("iso-8859-1"), "UTF-8");;  
        System.out.print(name+surname+mails+usernames+passwords);
        try
        {  
            currentCon = ConnectionManager.getConnection();
            stmt = currentCon.createStatement();
            rs = stmt.executeQuery("select * from users where username='" + usernames + "'");
            if(rs.next()){
                    out.print("Το ψευδώνυμο Υπάρχει Ήδη, Επαναλάβετε την διαδικασία με κάποιο άλλο<a href=\"./ \"> Εδώ </a>!!");
            }
            else {
                PreparedStatement ps=currentCon.prepareStatement("insert into users values(?,?,?,?,?)");  
                ps.setString(1,name);  
                ps.setString(2,surname);  
                ps.setString(3,mails);  
                ps.setString(4,usernames);  
                ps.setString(5,passwords);
                int i=ps.executeUpdate();  
                if(i>0){
                    try
                    {	    
                        UserBean user = new UserBean();
                        user.setUserName(usernames);
                        user.setPassword(passwords);
                        user = UserDAO.login(user);

                        if (user.isValid())
                        {
                            HttpSession session = request.getSession(true);	    
                            session.setAttribute("currentSessionUser",user); 
                            response.sendRedirect("index.jsp"); //logged-in page      		
                        }
                        else response.sendRedirect("invalidLogin.jsp"); //error page 
                   } 
                   catch (Throwable theException) 	    
                   {
                        System.out.println(theException); 
                   }
                }
            }         
        }catch (Exception e2) {System.out.println(e2);}  
          
    out.close();  
    }  
} 
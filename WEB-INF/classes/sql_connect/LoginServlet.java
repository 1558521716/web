
package sql_connect;

import sql_connect.UserBean;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {

    public int i;

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException {
        response.setContentType("text/html; charset=UTF-8");  
        PrintWriter out = response.getWriter();
        try
        {	    
             UserBean user = new UserBean();
             user.setUserName(request.getParameter("username"));
             user.setPassword(request.getParameter("password"));
             System.out.print(user.getUsername());
             user = UserDAO.login(user);

             if (user.isValid())
             {
                  HttpSession session = request.getSession(true);	    
                  session.setAttribute("currentSessionUser",user); 
                  System.out.print("asdasdasd"+user);
                  response.sendRedirect("index.jsp"); 		
             }
             else {
                  response.sendRedirect("index.jsp");
             }
        } 
        catch (Throwable theException) 	    
        {
             System.out.println(theException); 
        }
    }
}
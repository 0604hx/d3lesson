package org.nerve.d3lesson.web.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by zengxm on 2014/11/27.
 */
@WebServlet(name="chapter01", urlPatterns = "/chapter01")
public class Chapter01Servlet extends AbstractServlet {

    @Override
    public String getPath() {
        return "/chapter01/";
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = getParam(req, "type");
        render(type,req,resp);
    }
}

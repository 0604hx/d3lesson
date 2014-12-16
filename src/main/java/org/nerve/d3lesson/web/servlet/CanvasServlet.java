package org.nerve.d3lesson.web.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * canvas教程
 * Created by zengxm on 2014/12/15.
 */
@WebServlet(name="canvas", urlPatterns = "/canvas")
public class CanvasServlet extends AbstractServlet {
    @Override
    public String getPath() {
        return "/canvas/";
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = getParam(req, "type");
        render(type,req,resp);
    }
}
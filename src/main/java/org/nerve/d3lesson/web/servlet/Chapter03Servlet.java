package org.nerve.d3lesson.web.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 第三章
 *
 * 在这里，我们将展示一个中国地图，点击地图中的省份，可以放大到省份级别
 * 显示这个省里面的主要城市
 *
 * Created by zengxm on 2014/12/9.
 */
@WebServlet(name="chapter03", urlPatterns = "/chapter03")
public class Chapter03Servlet extends AbstractServlet {

    @Override
    public String getPath() {
        return "/chapter03/";
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = getParam(req, "type");
        render(type, req, resp);
    }
}

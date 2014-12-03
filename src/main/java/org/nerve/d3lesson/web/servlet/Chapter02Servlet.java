package org.nerve.d3lesson.web.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 第二章
 *
 * 在这里，我们将展示一个中国地图，并在地图中标出2013年各省份高考一本录取统计信息
 * 数据在 data/2013GKLQL.json 文件中 （此文件是使用 TxtToJSONImporter.java 工具生成）
 *
 * Created by zengxm on 2014/12/3.
 */
@WebServlet(name="chapter02", urlPatterns = "/chapter02")
public class Chapter02Servlet extends AbstractServlet {

    @Override
    public String getPath() {
        return "/chapter02/";
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = getParam(req, "type");
        render(type, req, resp);
    }
}

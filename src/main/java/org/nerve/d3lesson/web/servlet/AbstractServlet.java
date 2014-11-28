package org.nerve.d3lesson.web.servlet;

import org.nerve.d3lesson.common.StringUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by zengxm on 2014/11/27.
 */
public abstract class AbstractServlet extends HttpServlet {

    public static final String SUFFIX = ".ftl"; //模板文件后缀

    /**
     * 返回当前Servlet视图目录
     * 带斜杠 /
     * @return
     */
    public String getPath(){
        return "/";
    };

    /**
     * 渲染视图
     * @param viewName
     * @param req
     * @param resp
     * @return
     * @throws ServletException
     * @throws IOException
     */
    public void render(String viewName, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if(StringUtils.hasText(viewName)){
            if(!viewName.endsWith(SUFFIX))
                viewName += SUFFIX;
        }else{
            viewName = "index"+SUFFIX;
        }
        req.getRequestDispatcher(getPath()+viewName).forward(req,resp);
    }

    public boolean isGET(HttpServletRequest req){
        return req.getMethod().equalsIgnoreCase("GET");
    }

    protected String getParam(HttpServletRequest req, String name){
        return req.getParameter(name);
    }

    /**
     * 获取int类型的参数
     * @param req
     * @param name
     * @param defVal
     * @return
     */
    protected  int getParam(HttpServletRequest req, String name, int defVal){
        String p = getParam(req, name);

        try{
            return Integer.valueOf(p);
        }catch(Exception e){
            return defVal;
        }
    }
}
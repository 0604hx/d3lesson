package org.nerve.d3lesson.web.servlet;

import freemarker.ext.servlet.AllHttpScopesHashModel;
import freemarker.ext.servlet.FreemarkerServlet;
import freemarker.template.ObjectWrapper;
import freemarker.template.Template;
import freemarker.template.TemplateModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by zengxm on 2014/11/27.
 */
public class FreemarkerViewServlet extends FreemarkerServlet {

    @Override
    protected boolean preTemplateProcess(HttpServletRequest request, HttpServletResponse response, Template template, TemplateModel data) throws ServletException, IOException {
        AllHttpScopesHashModel model = (AllHttpScopesHashModel)data;
        model.put("base", request.getContextPath());

        /*
        put any data to your template model
         */

        return super.preTemplateProcess(request, response, template, model);
    }
}
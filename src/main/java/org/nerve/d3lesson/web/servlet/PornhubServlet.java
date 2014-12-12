package org.nerve.d3lesson.web.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 特别篇
 *
 * Pornhub发布了一幅交互式地图，根据网站流量统计记录分析哪个国家哪个城市的网民观看成人视频的时间最长。
 * Pornhub和YouPorn都被中国屏蔽，但出乎意料的是中国网民在Pornhub上观看成人视频的时间最长——14分34秒；
 * 俄罗斯是7分46秒，美国10分17秒。根据城市统计数据，北京网民看16分29秒，上海15分58秒，香港11分14秒
 *
 * http://www.kaoder.com/?m=thread&a=view&fid=53&tid=155270
 *
 * 地图网址：http://www.pornhub.com/infographic/longest
 * （需要翻墙）
 *
 * 这里就是将原网站的地图copy下来，加入了一些注释，并对js代码进行了格式化
 *
 * Created by zengxm on 2014/12/12.
 */
@WebServlet(name="pornhub", urlPatterns = "/pornhub")
public class PornhubServlet extends AbstractServlet {

    @Override
    public String getPath() {
        return "/pornhub/";
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = getParam(req, "type");
        render(type, req, resp);
    }
}

package org.nerve.d3lesson.dataimport;

import com.alibaba.fastjson.JSON;
import org.nerve.d3lesson.common.tools.PinyinTool;
import org.nerve.d3lesson.common.tools.TxtImporter;
import org.nerve.d3lesson.common.tools.TxtLineDataFixer;
import org.nerve.d3lesson.common.tools.impl.TxtToJSONImporter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 导入中国主要城市的经纬度数据到json文件中
 *
 * 最后的格式是：
 * {
 *     "id":"GUANGDONG",   //省份拼音
 *     "cities":[           //城市列表
 *          {"name":"广州","g":3231,"l":1231},
 *     ]
 * }
 *
 * 原始数据(在 /web/data/origin/全国主要城市经纬度查询.txt）：
 * 全国主要城市经纬度查询（name=城市名，g=经度，l=纬度）
     安徽省 合肥 北纬31.52 东经117.17
     安徽省 安庆 北纬30.31 东经117.02
     安徽省 蚌埠 北纬32.56 东经117.21
     安徽省 亳州 北纬33.52 东经115.47
     安徽省 巢湖 北纬31.36 东经117.52
     安徽省 滁州 北纬32.18 东经118.18
     安徽省 阜阳 北纬32.54 东经115.48
     安徽省 贵池 北纬30.39 东经117.28
     安徽省 淮北 北纬33.57 东经116.47
     安徽省 淮南 北纬32.37 东经116.58
 * Created by zengxm on 2014/12/10.
 */
public class ImportCitiesOfChina  {

    public static class CitiesFixer implements TxtLineDataFixer{
        private PinyinTool tool = new PinyinTool();

        @Override
        public void fix(Object obj) {
            try{
                Map<String, Object> map = (Map<String, Object>)obj;

                if(map.containsKey("p")){
                    String p = ((String)map.get("p")).substring(0,2);
                    map.put("p", p);
                    if(p.equals("陕西")){
                        map.put("id", "SHAANXI");
                    }else if(p.equals("重庆"))
                        map.put("id","CHONGQING");
                    else
                        map.put("id", tool.toPinYin(p));
                }
            }catch(Exception e){
                e.printStackTrace();
            }
        }

        @Override
        public String before(String line) {
            return line.replaceAll("北纬","").replaceAll("东经","");
        }
    }

    public static void main(String[] a) throws Exception{
        TxtImporter importer = new TxtToJSONImporter(
                "F:\\workspace\\intelliJ_13\\d3Lesson\\web\\data\\origin\\全国主要城市经纬度查询.txt",
                new String[]{"p","name","l","g"},
                new CitiesFixer()
        );

        importer.run();
        Map<String,Object> map = (Map<String, Object>)importer.getData();
        //获取数据
        List<Map<String, Object>> datas = (List<Map<String, Object>>)map.get(TxtToJSONImporter.DATAS);
        //我们需要对数据进行合并，就是说一个省的都归类到一起
        Map<String, Object> endData = new HashMap<String, Object>();

        for(Map<String, Object> m:datas){
            String key = (String)m.get("id");
            Map<String, Object> d = new HashMap<String, Object>();
            d.put("name", m.get("name"));
            d.put("g", m.get("g"));
            d.put("l", m.get("l"));

            if(endData.containsKey(key)){
                ((List<Map<String, Object>>)endData.get(key)).add(d);
            }else{
                List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
                list.add(d);

                endData.put(key, list);
            }
        }
        System.out.println(importer.toString());

        System.out.println(JSON.toJSONString(endData));
    }
}

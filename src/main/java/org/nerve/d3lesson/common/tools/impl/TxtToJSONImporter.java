package org.nerve.d3lesson.common.tools.impl;

import com.alibaba.fastjson.JSON;
import org.nerve.d3lesson.common.tools.PinyinTool;
import org.nerve.d3lesson.common.tools.TxtImporter;
import org.nerve.d3lesson.common.tools.TxtLineDataFixer;

import java.util.*;

/**
 * 从txt导入规则的数据到JSON格式
 *
 * 通用格式：
 * 第一行：标题
 * 第二行开始就是一行行的规则数据，以空格隔开
 *
 * Created by zengxm on 2014/12/3.
 */
public class TxtToJSONImporter extends AbstractTxtLineImporter {

    private Map<String, Object> map = new HashMap<String, Object>();
    private long index = 0;
    private String columns[] ;
    private String reg = "[\\s]{1,}";       //正则表达式，删除多余空格用的
    private TxtLineDataFixer fixer;

    public static final String TITLE = "_title";
    public static final String DATAS = "datas";

    public TxtToJSONImporter(String fileName,String[] names) throws Exception{
        setFile(fileName);

        if(names == null || names.length ==0)
            throw new RuntimeException("columns 参数不正确");
        columns = names;
    }

    public TxtToJSONImporter(String fileName,String[] names, TxtLineDataFixer fixer) throws Exception{
        this(fileName, names);

        this.fixer = fixer;
    }
    @Override
    public void doWithLine(String line) throws Exception {
        //获取标题
        if(index == 0){
            map.put(TITLE, line);
            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            map.put(DATAS, list);
        }else{
            Map<String, Object> d = new HashMap<String, Object>();

            if(fixer != null)
                line = fixer.before(line);

            String ds[] = line.replaceAll(reg," ").trim().split(" ");

            int ci = 0;
            for(int i=0;i<ds.length;i++){
                if(ds[i].trim().length()>0){
                    try{
                        if(ds[i].indexOf(".")>0)
                            d.put(columns[ci], Double.valueOf(ds[i]));
                        else
                            d.put(columns[ci], Long.valueOf(ds[i]));
                    }catch(Exception e){
                        d.put(columns[ci], ds[i]);
                    }

                    ci++;
                    if(ci >= columns.length)
                        continue;
                }
            }
            for(;ci<columns.length;ci++)
                d.put(columns[ci], "");

            addLine(d);
        }

        index ++;
    }

    private void addLine(Map<String, Object> d){
        if(fixer != null)
            fixer.fix(d);
        ((List<Map<String, Object>>)map.get(DATAS)).add(d);
    }

    @Override
    public String toString() {
        return JSON.toJSONString(map);
    }

    @Override
    public Object getData() {
        return map;
    }

    /**
     * 测试
     * @param a
     */
    public static void main(String[] a) throws Exception{
        final PinyinTool pyTool = new PinyinTool();
        TxtImporter imp = new TxtToJSONImporter(
                "C:\\Users\\zengxm\\Desktop\\2013GKLQL.txt",
                new String[]{"index","province","total", "enter","rate"},
                new TxtLineDataFixer() {
                    @Override
                    public void fix(Object obj) {
                        Map<String, Object> map = (Map<String, Object>)obj;
                        if(obj != null){
                            if(map.containsKey("province")){
                                Object p = map.get("province");
                                try{
                                    map.put("id", pyTool.toPinYin((String)p,""));
                                }catch(Exception e){
                                    map.put("id", p);
                                }
                            }
                        }
                    }

                    @Override
                    public String before(String line) {
                        return null;
                    }
                }
        );

        imp.run();
        System.out.println(imp.toString());
    }
}
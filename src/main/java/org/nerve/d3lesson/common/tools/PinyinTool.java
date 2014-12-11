package org.nerve.d3lesson.common.tools;

import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;

import java.util.Arrays;

/**
 *
 * Created by zengxm on 2014/12/4.
 */
public class PinyinTool {
    HanyuPinyinOutputFormat format = null;
    public static enum Type {
        UPPERCASE,              //全部大写
        LOWERCASE,              //全部小写
        FIRSTUPPER              //首字母大写
    }

    public PinyinTool(){
        format = new HanyuPinyinOutputFormat();
        format.setCaseType(HanyuPinyinCaseType.UPPERCASE);
        format.setToneType(HanyuPinyinToneType.WITHOUT_TONE);
    }

    public String toPinYin(String str) throws BadHanyuPinyinOutputFormatCombination{
        return toPinYin(str, "", Type.UPPERCASE);
    }

    public String toPinYin(String str,String spera) throws BadHanyuPinyinOutputFormatCombination{
        return toPinYin(str, spera, Type.UPPERCASE);
    }

    /**
     * 将str转换成拼音，如果不是汉字或者没有对应的拼音，则不作转换
     * 如： 明天 转换成 MINGTIAN
     * @param str
     * @param spera
     * @return
     * @throws BadHanyuPinyinOutputFormatCombination
     */
    public String toPinYin(String str, String spera, Type type) throws BadHanyuPinyinOutputFormatCombination {
        if(str == null || str.trim().length()==0)
            return "";
        if(type == Type.UPPERCASE)
            format.setCaseType(HanyuPinyinCaseType.UPPERCASE);
        else
            format.setCaseType(HanyuPinyinCaseType.LOWERCASE);

        String py = "";
        String temp = "";
        String[] t;
        for(int i=0;i<str.length();i++){
            char c = str.charAt(i);
            if((int)c <= 128)
                py += c;
            else{
                t = PinyinHelper.toHanyuPinyinStringArray(c, format);
                if(t == null)
                    py += c;
                else{
                    temp = t[0];
                    if(type == Type.FIRSTUPPER)
                        temp = t[0].toUpperCase().charAt(0)+temp.substring(1);
                    py += temp+(i==str.length()-1?"":spera);
                }
            }
        }
        return py.trim();
    }

    public static void main(String[] args)  throws Exception{
        PinyinTool tool = new PinyinTool();

        System.out.println(tool.toPinYin("明天ABC"));
        System.out.println(tool.toPinYin("明天ABC","_"));
        System.out.println(tool.toPinYin("明天ABC","_", PinyinTool.Type.LOWERCASE));
        System.out.println(tool.toPinYin("明天ABC","_", PinyinTool.Type.FIRSTUPPER));

        char c='重';
        System.out.println("汉语拼音："+Arrays.toString(PinyinHelper.toHanyuPinyinStringArray(c)));
        System.out.println("通用拼音："+Arrays.toString(PinyinHelper.toTongyongPinyinStringArray(c)));
        System.out.println("威妥玛拼音："+Arrays.toString(PinyinHelper.toWadeGilesPinyinStringArray(c)));
        System.out.println("注音符号拼音："+Arrays.toString(PinyinHelper.toMPS2PinyinStringArray(c)));
        System.out.println("耶魯拼音："+Arrays.toString(PinyinHelper.toYalePinyinStringArray(c)));
        System.out.println("国语罗马字："+Arrays.toString(PinyinHelper.toGwoyeuRomatzyhStringArray(c)));
    }
}
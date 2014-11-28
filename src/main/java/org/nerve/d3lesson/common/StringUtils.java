package org.nerve.d3lesson.common;

/**
 * Created by zengxm on 2014/11/27.
 */
public final class StringUtils {

    /**
     * 判断是否有内容
     * @param str
     * @return
     */
    public static boolean hasText(String str){
        return str!=null && str.trim().length()>0;
    }
}
package org.nerve.d3lesson.common.tools;

/**
 * 此方法包含了对数据的处理（单行的规则数据）
 *
 * 通常在解析到数据对象后，在保存前被调用，用来处理一下额外的数据或者格式装换
 * 比如一行数据是：
 * 台湾 1000
 *
 * 但是我想再加一个列，就是“台湾”这个词的拼音，即最终数据：
 * 台湾 TAIWAN 1000
 *
 * 那么可以加入此接口的实现类去完成
 *
 * 建议使用Map作为参数传入 fix 方法中
 * Created by zengxm on 2014/12/4.
 */
public interface TxtLineDataFixer {

    public void fix(Object obj);

    /**
     * 在处理一行数据前，要做的一些操作
     * @param line
     * @return
     */
    public String before(String line);
}

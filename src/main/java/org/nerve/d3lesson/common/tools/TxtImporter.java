package org.nerve.d3lesson.common.tools;

/**
 * 导入txt格式的文件数据
 * @author zengxm 2014-9-25
 */
public interface TxtImporter {

	/**
	 *<pre>
	 *处理一行的数据
	 *</pre>
	 * @param line
	 */
	public void doWithLine(String line) throws Exception;
	
	/**
	 * <pre>
	 *开始干活
	 *</pre>
	 * @throws Exception
	 */
	public void run() throws Exception;
	
	public void setFile(String filepath);
}
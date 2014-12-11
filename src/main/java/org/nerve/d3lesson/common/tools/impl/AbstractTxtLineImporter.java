package org.nerve.d3lesson.common.tools.impl;

import org.nerve.d3lesson.common.tools.TxtImporter;

import java.io.BufferedReader;
import java.io.FileReader;

/**
 * 适合导入以行为单位的格式化的数据
 * @author zengxm 2014-9-25
 */
public abstract class AbstractTxtLineImporter implements TxtImporter {
	
	protected String fileName;
	
	public AbstractTxtLineImporter(){
	}
	
	public AbstractTxtLineImporter(String fileName){
		this.fileName = fileName;
	}
	
	@Override
	public void setFile(String filepath) {
		this.fileName = filepath;
	}
	
	@Override
	public void run() throws Exception{
		BufferedReader br = new BufferedReader(new FileReader(fileName));
		String line = null;
		while((line=br.readLine())!=null){
			this.doWithLine(line.trim());
		}
		br.close();
	}
}
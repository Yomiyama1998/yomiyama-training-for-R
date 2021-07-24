//(Fuji Is Just) ImageJ 2.1.0;Java 1.8.0_172[64bit]

/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.

processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

//開いているファイルをすべて閉じてくれる関数
function allclose() { 
      while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      } 

}


//errorが出るので入力元ファイルと出力先ファイルを分けた方が無難

function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	open(input+File.separator+file);//fileを開く;inputの後にfile.separatorを入れて下さい
	run("16-bit");//何ビットのファイルで開くか指定
	//このコメントより下にコピペして下さい。
	//Tiff保存する時には、saveAsするときには下のテストみたいにsaveAsのあとにallclose()関数を入れて下さい

	//コピペ先
	run("Split Channels");//SplitChannnels
	selectWindow("C2-"+file);//splitしてどのチャンネルを開くか指定
    saveAs("Tiff", output+File.separator+"Green_"+file);  //保存
    allclose();
    //コピペ終わり
	print("Processing: " + input + File.separator + file);
	print("Saving to: " + output);
}




